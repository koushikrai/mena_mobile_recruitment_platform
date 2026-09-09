from datetime import date, timedelta
from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select, and_
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.models.user import User
from app.models.vault import DocumentVault, ComplianceReminder
from app.schemas.vault import ComplianceReminderResponse
from app.core.security import get_current_user

router = APIRouter(prefix="/compliance", tags=["Compliance & Expiry Tracker"])

@router.get("/reminders", response_model=List[ComplianceReminderResponse])
async def list_compliance_reminders(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    stmt = (
        select(ComplianceReminder)
        .where(
            and_(
                ComplianceReminder.user_id == current_user.id,
                ComplianceReminder.is_resolved == False
            )
        )
        .order_by(ComplianceReminder.due_date.asc())
    )
    reminders = (await db.execute(stmt)).scalars().all()
    if not reminders:
        # Check if passport documents exist to generate
        reminders = await check_and_generate_reminders(current_user, db)
    
    # If still empty, add default GCC readiness compliance reminders
    if not reminders:
        seed_reminders = [
            ComplianceReminder(
                user_id=current_user.id,
                reminder_type="gcc_180_day_rule",
                due_date=date.today() + timedelta(days=180),
                message="GCC 180-Day Rule: Ensure your primary passport has >= 6 months validity for Saudi/UAE visa stamping.",
                is_resolved=False
            ),
            ComplianceReminder(
                user_id=current_user.id,
                reminder_type="gamca_medical_booking",
                due_date=date.today() + timedelta(days=30),
                message="GAMCA Medical Fitness: Book your authorized biometric health screening slot prior to embassy submission.",
                is_resolved=False
            ),
            ComplianceReminder(
                user_id=current_user.id,
                reminder_type="degree_attestation",
                due_date=date.today() + timedelta(days=45),
                message="Educational Attestation: Submit technical certificates for Saudi Cultural Attache & MOFA apostille stamp.",
                is_resolved=False
            ),
        ]
        db.add_all(seed_reminders)
        await db.commit()
        for r in seed_reminders:
            await db.refresh(r)
        return seed_reminders

    return reminders

@router.post("/check-expiry", response_model=List[ComplianceReminderResponse])
async def check_and_generate_reminders(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Scans user's travel documents for GCC regulatory compliance:
    - Alerts if passport expires within 180 days (6 months)
    - Alerts if passport expires within 90 days (critical)
    """
    stmt = select(DocumentVault).where(
        and_(
            DocumentVault.user_id == current_user.id,
            DocumentVault.document_type == "passport",
            DocumentVault.expiry_date != None
        )
    )
    passports = (await db.execute(stmt)).scalars().all()
    today = date.today()
    generated = []

    for p in passports:
        days_left = (p.expiry_date - today).days
        
        # Check 180 days rule
        if days_left <= 180 and days_left > 90:
            msg = f"Your passport {p.passport_number} has {days_left} days left. GCC immigration requires at least 6 months validity for visa stamping."
            rem_type = "passport_180_days"
        elif days_left <= 90:
            msg = f"CRITICAL: Your passport {p.passport_number} expires in {days_left} days! Immediate renewal required for MENA relocation."
            rem_type = "passport_90_days"
        else:
            continue

        # Check if reminder already exists
        existing_stmt = select(ComplianceReminder).where(
            and_(
                ComplianceReminder.user_id == current_user.id,
                ComplianceReminder.document_id == p.id,
                ComplianceReminder.reminder_type == rem_type,
                ComplianceReminder.is_resolved == False
            )
        )
        existing = (await db.execute(existing_stmt)).scalar_one_or_none()
        if not existing:
            reminder = ComplianceReminder(
                user_id=current_user.id,
                document_id=p.id,
                reminder_type=rem_type,
                due_date=p.expiry_date,
                message=msg,
                is_resolved=False
            )
            db.add(reminder)
            generated.append(reminder)

    if generated:
        await db.commit()
        for r in generated:
            await db.refresh(r)

    # Return all active reminders
    return await list_compliance_reminders(current_user, db)
