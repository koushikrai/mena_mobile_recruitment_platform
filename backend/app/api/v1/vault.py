from uuid import UUID
from datetime import date
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.models.user import User
from app.models.candidate import CandidateProfile
from app.models.vault import DocumentVault
from app.schemas.vault import (
    DocumentVaultResponse,
    MRZVerifyRequest,
    MRZVerifyResponse,
    ParsedCVResponse
)
from app.core.security import get_current_user
from app.services.mrz_service import parse_td3_mrz
from app.services.cv_parser_service import parse_cv_with_ai
from app.services.storage_service import save_uploaded_file
from app.services.readiness_service import calculate_relocation_readiness

router = APIRouter(prefix="/vault", tags=["Document Vault & AI Services"])

@router.get("/documents", response_model=List[DocumentVaultResponse])
async def list_vault_documents(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    stmt = (
        select(DocumentVault)
        .where(DocumentVault.user_id == current_user.id)
        .order_by(DocumentVault.created_at.desc())
    )
    docs = (await db.execute(stmt)).scalars().all()
    return docs

@router.post("/mrz/verify", response_model=MRZVerifyResponse)
async def verify_mrz(req: MRZVerifyRequest):
    """Directly verifies ICAO Doc 9303 TD3 2-line MRZ."""
    result = parse_td3_mrz(req.mrz_raw_line1, req.mrz_raw_line2)
    return result

@router.post("/cv/parse", response_model=ParsedCVResponse)
async def parse_cv_file(
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user)
):
    """Uploads CV and runs AI extraction (Gemini / Heuristic)."""
    file_bytes = await file.read()
    if not file_bytes:
        raise HTTPException(status_code=400, detail="Empty file uploaded")
        
    parsed_cv = await parse_cv_with_ai(file_bytes, file.filename or "resume.pdf")
    return parsed_cv

@router.post("/upload", response_model=DocumentVaultResponse, status_code=status.HTTP_201_CREATED)
async def upload_vault_document(
    document_type: str = Form(..., pattern="^(passport|cv_resume)$"),
    file: UploadFile = File(...),
    # Optional passport fields if manual or pre-scanned
    mrz_line1: Optional[str] = Form(None),
    mrz_line2: Optional[str] = Form(None),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    file_bytes = await file.read()
    if not file_bytes:
        raise HTTPException(status_code=400, detail="Empty file uploaded")

    filename, file_url, size_bytes = save_uploaded_file(file_bytes, file.filename or "document")
    mime_type = file.content_type or "application/octet-stream"

    doc = DocumentVault(
        user_id=current_user.id,
        document_type=document_type,
        file_name=file.filename or filename,
        file_url=file_url,
        file_size_bytes=size_bytes,
        mime_type=mime_type,
        upload_source="manual",
        is_verified=False,
        verification_status="pending"
    )

    if document_type == "passport":
        if mrz_line1 and mrz_line2:
            mrz_res = parse_td3_mrz(mrz_line1, mrz_line2)
            doc.passport_number = mrz_res.passport_number
            doc.issuing_country = mrz_res.issuing_country
            doc.country_code_icao = mrz_res.country_code_icao
            doc.passport_nationality = mrz_res.nationality
            doc.surname = mrz_res.surname
            doc.given_names = mrz_res.given_names
            doc.date_of_birth = mrz_res.date_of_birth
            doc.gender = mrz_res.gender
            doc.expiry_date = mrz_res.expiry_date
            doc.mrz_raw_line1 = mrz_line1
            doc.mrz_raw_line2 = mrz_line2
            doc.is_mrz_checksum_valid = mrz_res.is_valid
            doc.has_six_months_validity = mrz_res.has_six_months_validity
            doc.is_verified = mrz_res.is_valid and mrz_res.has_six_months_validity
            doc.verification_status = "verified" if doc.is_verified else "expired" if not mrz_res.has_six_months_validity else "rejected"
        else:
            # Placeholder for manual verification
            doc.passport_number = "PENDING_SCAN"
            doc.expiry_date = date.today()
            doc.has_six_months_validity = True

    elif document_type == "cv_resume":
        parsed = await parse_cv_with_ai(file_bytes, file.filename or "resume.pdf")
        doc.extracted_full_text = parsed.raw_text
        doc.parsed_data = parsed.model_dump()
        doc.is_primary_cv = True
        doc.is_verified = True
        doc.verification_status = "verified"

    db.add(doc)
    await db.flush()

    # Recalculate profile score
    prof_stmt = select(CandidateProfile).where(CandidateProfile.user_id == current_user.id)
    profile = (await db.execute(prof_stmt)).scalar_one_or_none()
    if profile:
        doc_stmt = select(DocumentVault).where(DocumentVault.user_id == current_user.id)
        all_docs = (await db.execute(doc_stmt)).scalars().all()
        readiness = calculate_relocation_readiness(profile, all_docs)
        profile.relocation_readiness_score = readiness.relocation_readiness_score

    await db.commit()
    await db.refresh(doc)
    return doc
