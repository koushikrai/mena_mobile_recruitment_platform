import uuid
from typing import List, Optional
from uuid import UUID
from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import select, or_, and_
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.models.user import User
from app.models.job import Job, Company, JobBookmark, WalkinDrive, WalkinRegistration
from app.schemas.job import (
    JobResponse,
    WalkinDriveResponse,
    WalkinRegisterRequest,
    WalkinRegistrationResponse
)
from app.core.security import get_current_user, get_optional_current_user
from app.core.realtime import manager

router = APIRouter(prefix="/jobs", tags=["Jobs & Drives"])


@router.get("", response_model=List[JobResponse])
async def list_jobs(
    search_query: Optional[str] = Query(None),
    countries: Optional[List[str]] = Query(None),
    region: Optional[str] = Query(None),
    sector: Optional[str] = Query(None),
    visa_sponsored: Optional[bool] = Query(None),
    min_salary: Optional[float] = Query(None),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    current_user: Optional[User] = Depends(get_optional_current_user),
    db: AsyncSession = Depends(get_db)
):
    stmt = (
        select(Job)
        .join(Company, Job.company_id == Company.id)
        .options(selectinload(Job.company))
        .where(Job.is_active == True)
    )

    if search_query and isinstance(search_query, str) and search_query.strip():
        term = f"%{search_query.strip()}%"
        stmt = stmt.where(
            or_(
                Job.title.ilike(term),
                Job.reference_code.ilike(term),
                Job.sector.ilike(term),
                Job.city.ilike(term),
                Company.name.ilike(term)
            )
        )

    if region and isinstance(region, str) and region.strip().lower() not in ["global", "all"]:
        reg = region.strip().lower()
        region_map = {
            "gcc": ["KSA", "SAU", "UAE", "ARE", "QATAR", "QAT", "KUWAIT", "KWT", "OMAN", "OMN", "BAHRAIN", "BHR"],
            "apac": ["SGP", "MYS", "IND", "JPN", "KOR", "VNM", "IDN", "PHL", "THA", "AUS"],
            "emea": ["GBR", "UK", "DEU", "FRA", "NLD", "ZAF", "IRL", "ESP", "ITA", "CHE", "SWE"],
            "usa": ["USA", "CAN", "MEX"],
            "oceania": ["AUS", "NZL", "FJI", "PNG"],
        }
        if reg in region_map:
            stmt = stmt.where(Job.country_code.in_(region_map[reg]))

    if countries:
        country_set = set()
        for c in countries:
            upper = c.strip().upper()
            country_set.add(upper)
            if upper in ["KSA", "SAUDI ARABIA", "SAUDI"]:
                country_set.update(["KSA", "SAU"])
            elif upper in ["UAE", "UNITED ARAB EMIRATES", "DUBAI"]:
                country_set.update(["UAE", "ARE"])
            elif upper in ["QATAR", "QAT"]:
                country_set.update(["QATAR", "QAT"])
            elif upper in ["KUWAIT", "KWT"]:
                country_set.update(["KUWAIT", "KWT"])
            elif upper in ["OMAN", "OMN"]:
                country_set.update(["OMAN", "OMN"])
            elif upper in ["BAHRAIN", "BHR"]:
                country_set.update(["BAHRAIN", "BHR"])
        stmt = stmt.where(Job.country_code.in_(country_set))

    if sector:
        stmt = stmt.where(Job.sector.ilike(f"%{sector.strip()}%"))

    if visa_sponsored is True:
        stmt = stmt.where(Job.visa_status.ilike("%Provided%") | Job.visa_status.ilike("%Sponsored%"))

    if min_salary is not None:
        stmt = stmt.where(Job.salary_max >= min_salary)

    stmt = stmt.order_by(Job.is_urgent.desc(), Job.created_at.desc())
    stmt = stmt.offset((page - 1) * page_size).limit(page_size)

    try:
        results = (await db.execute(stmt)).scalars().all()
    except Exception:
        return []

    # Check bookmarks if user logged in
    bookmarked_ids = set()
    if current_user:
        b_stmt = select(JobBookmark.job_id).where(JobBookmark.user_id == current_user.id)
        b_rows = (await db.execute(b_stmt)).scalars().all()
        bookmarked_ids = set(b_rows)

    response = []
    for job in results:
        resp = JobResponse(
            id=job.id,
            company_id=job.company_id,
            company_name=job.company.name if job.company else None,
            company_logo=job.company.logo_url if job.company else None,
            reference_code=job.reference_code,
            title=job.title,
            sector=job.sector,
            country_code=job.country_code,
            city=job.city,
            salary_min=float(job.salary_min),
            salary_max=float(job.salary_max),
            salary_currency=job.salary_currency,
            visa_status=job.visa_status,
            rotation_schedule=job.rotation_schedule,
            required_experience_years=float(job.required_experience_years),
            required_skills=job.required_skills or [],
            relocation_benefits=job.relocation_benefits or [],
            description=job.description,
            zero_recruitment_fee_guarantee=job.zero_recruitment_fee_guarantee,
            is_urgent=job.is_urgent,
            is_bookmarked=(job.id in bookmarked_ids),
            created_at=job.created_at
        )
        response.append(resp)

    return response

# Walk-in Drives
@router.get("/walkin-drives", response_model=List[WalkinDriveResponse])
@router.get("/walkin-drives/all", response_model=List[WalkinDriveResponse])
async def list_walkin_drives(db: AsyncSession = Depends(get_db)):
    stmt = select(WalkinDrive).options(selectinload(WalkinDrive.company)).where(WalkinDrive.is_active == True)
    drives = (await db.execute(stmt)).scalars().all()
    
    return [
        WalkinDriveResponse(
            id=d.id,
            company_id=d.company_id,
            company_name=d.company.name if d.company else None,
            title=d.title,
            country_code=d.country_code,
            city=d.city,
            venue_name=d.venue_name,
            venue_address=d.venue_address,
            start_date=d.start_date,
            end_date=d.end_date,
            time_slots=d.time_slots or [],
            available_quotas=d.available_quotas,
            registered_count=d.registered_count,
            qr_code_prefix=d.qr_code_prefix,
            is_active=d.is_active
        ) for d in drives
    ]

@router.post("/walkin-drives/{drive_id}/register", response_model=WalkinRegistrationResponse)
async def register_for_walkin(
    drive_id: UUID,
    req: WalkinRegisterRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    drive_stmt = select(WalkinDrive).where(WalkinDrive.id == drive_id)
    drive = (await db.execute(drive_stmt)).scalar_one_or_none()
    if not drive:
        raise HTTPException(status_code=404, detail="Walk-in recruitment drive not found")

    # Check if already registered
    reg_stmt = select(WalkinRegistration).where(
        and_(WalkinRegistration.drive_id == drive_id, WalkinRegistration.user_id == current_user.id)
    )
    existing = (await db.execute(reg_stmt)).scalar_one_or_none()
    if existing:
        return existing

    # Generate fast-track QR pass code
    pass_code = f"{drive.qr_code_prefix}{uuid.uuid4().hex[:8].upper()}"
    reg = WalkinRegistration(
        drive_id=drive.id,
        user_id=current_user.id,
        time_slot=req.time_slot,
        qr_pass_code=pass_code,
        status="registered"
    )
    drive.registered_count += 1
    db.add(reg)
    await db.commit()
    await db.refresh(reg)

    # Real-time WebSocket broadcasts
    await manager.broadcast_to_topic(
        "topic:walkin_drives",
        "walkin_quota_updated",
        {
            "drive_id": str(drive.id),
            "title": drive.title,
            "registered_count": drive.registered_count,
            "available_quotas": drive.available_quotas,
            "remaining_slots": max(0, drive.available_quotas - drive.registered_count),
            "timestamp": datetime.utcnow().isoformat(),
        }
    )
    await manager.broadcast_to_user(
        current_user.id,
        "walkin_registered",
        {
            "drive_id": str(drive.id),
            "registration_id": str(reg.id),
            "qr_pass_code": reg.qr_pass_code,
            "time_slot": reg.time_slot,
            "title": drive.title,
            "venue": drive.venue_name,
        }
    )

    return reg


@router.get("/{job_id}", response_model=JobResponse)
async def get_job(
    job_id: UUID,
    current_user: Optional[User] = Depends(get_optional_current_user),
    db: AsyncSession = Depends(get_db)
):
    stmt = select(Job).options(selectinload(Job.company)).where(Job.id == job_id)
    job = (await db.execute(stmt)).scalar_one_or_none()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")

    is_bookmarked = False
    if current_user:
        b_stmt = select(JobBookmark).where(
            and_(JobBookmark.user_id == current_user.id, JobBookmark.job_id == job.id)
        )
        is_bookmarked = bool((await db.execute(b_stmt)).scalar_one_or_none())

    return JobResponse(
        id=job.id,
        company_id=job.company_id,
        company_name=job.company.name if job.company else None,
        company_logo=job.company.logo_url if job.company else None,
        reference_code=job.reference_code,
        title=job.title,
        sector=job.sector,
        country_code=job.country_code,
        city=job.city,
        salary_min=float(job.salary_min),
        salary_max=float(job.salary_max),
        salary_currency=job.salary_currency,
        visa_status=job.visa_status,
        rotation_schedule=job.rotation_schedule,
        required_experience_years=float(job.required_experience_years),
        required_skills=job.required_skills or [],
        relocation_benefits=job.relocation_benefits or [],
        description=job.description,
        zero_recruitment_fee_guarantee=job.zero_recruitment_fee_guarantee,
        is_urgent=job.is_urgent,
        is_bookmarked=is_bookmarked,
        created_at=job.created_at
    )

@router.post("/{job_id}/bookmark")
async def toggle_bookmark(
    job_id: UUID,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    stmt = select(JobBookmark).where(
        and_(JobBookmark.user_id == current_user.id, JobBookmark.job_id == job_id)
    )
    bookmark = (await db.execute(stmt)).scalar_one_or_none()

    if bookmark:
        await db.delete(bookmark)
        await db.commit()
        return {"bookmarked": False, "message": "Bookmark removed"}
    else:
        new_bookmark = JobBookmark(user_id=current_user.id, job_id=job_id)
        db.add(new_bookmark)
        await db.commit()
        return {"bookmarked": True, "message": "Job bookmarked"}
