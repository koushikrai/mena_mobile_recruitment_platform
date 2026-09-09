from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.models.user import User
from app.models.candidate import CandidateProfile, CandidateExperience, CandidateEducation, CandidateSkill
from app.models.vault import DocumentVault
from app.schemas.candidate import (
    CandidateProfileCreate,
    CandidateProfileUpdate,
    CandidateProfileResponse,
    ExperienceCreate,
    ExperienceResponse,
    EducationCreate,
    EducationResponse,
    SkillCreate,
    SkillResponse,
    ReadinessScoreResponse
)
from app.core.security import get_current_user
from app.services.readiness_service import calculate_relocation_readiness

router = APIRouter(prefix="/candidates", tags=["Candidate Profiles"])

@router.get("/me", response_model=CandidateProfileResponse)
async def get_my_profile(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    stmt = (
        select(CandidateProfile)
        .where(CandidateProfile.user_id == current_user.id)
        .options(
            selectinload(CandidateProfile.experiences),
            selectinload(CandidateProfile.educations),
            selectinload(CandidateProfile.skills)
        )
    )
    profile = (await db.execute(stmt)).scalar_one_or_none()
    if not profile:
        raise HTTPException(status_code=404, detail="Candidate profile not found")
    return profile

@router.put("/profile", response_model=CandidateProfileResponse)
async def update_my_profile(
    req: CandidateProfileUpdate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    stmt = (
        select(CandidateProfile)
        .where(CandidateProfile.user_id == current_user.id)
        .options(
            selectinload(CandidateProfile.experiences),
            selectinload(CandidateProfile.educations),
            selectinload(CandidateProfile.skills)
        )
    )
    profile = (await db.execute(stmt)).scalar_one_or_none()
    if not profile:
        raise HTTPException(status_code=404, detail="Candidate profile not found")

    update_data = req.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(profile, field, value)

    # Re-evaluate readiness score
    doc_stmt = select(DocumentVault).where(DocumentVault.user_id == current_user.id)
    documents = (await db.execute(doc_stmt)).scalars().all()
    readiness = calculate_relocation_readiness(profile, documents)
    profile.relocation_readiness_score = readiness.relocation_readiness_score

    await db.commit()
    await db.refresh(profile)
    return profile

@router.get("/readiness", response_model=ReadinessScoreResponse)
async def get_readiness_score(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    stmt = (
        select(CandidateProfile)
        .where(CandidateProfile.user_id == current_user.id)
        .options(selectinload(CandidateProfile.educations))
    )
    profile = (await db.execute(stmt)).scalar_one_or_none()
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")

    doc_stmt = select(DocumentVault).where(DocumentVault.user_id == current_user.id)
    documents = (await db.execute(doc_stmt)).scalars().all()

    result = calculate_relocation_readiness(profile, documents)
    return result

@router.post("/experiences", response_model=ExperienceResponse)
async def add_experience(
    req: ExperienceCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    stmt = select(CandidateProfile).where(CandidateProfile.user_id == current_user.id)
    profile = (await db.execute(stmt)).scalar_one_or_none()
    if not profile:
        raise HTTPException(status_code=404, detail="Candidate profile not found")

    exp = CandidateExperience(
        profile_id=profile.id,
        **req.model_dump()
    )
    db.add(exp)
    await db.commit()
    await db.refresh(exp)
    return exp

@router.post("/educations", response_model=EducationResponse)
async def add_education(
    req: EducationCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    stmt = select(CandidateProfile).where(CandidateProfile.user_id == current_user.id)
    profile = (await db.execute(stmt)).scalar_one_or_none()
    if not profile:
        raise HTTPException(status_code=404, detail="Candidate profile not found")

    edu = CandidateEducation(
        profile_id=profile.id,
        **req.model_dump()
    )
    db.add(edu)
    await db.commit()
    await db.refresh(edu)
    return edu

@router.post("/skills", response_model=SkillResponse)
async def add_skill(
    req: SkillCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    stmt = select(CandidateProfile).where(CandidateProfile.user_id == current_user.id)
    profile = (await db.execute(stmt)).scalar_one_or_none()
    if not profile:
        raise HTTPException(status_code=404, detail="Candidate profile not found")

    skill = CandidateSkill(
        profile_id=profile.id,
        **req.model_dump()
    )
    db.add(skill)
    await db.commit()
    await db.refresh(skill)
    return skill
