from typing import Optional, List
from uuid import UUID
from datetime import datetime
from pydantic import BaseModel, Field, ConfigDict

class ExperienceCreate(BaseModel):
    company: str
    title: str
    country: str
    city: Optional[str] = None
    start_date: str
    end_date: Optional[str] = None
    is_current: bool = False
    description: Optional[str] = None

class ExperienceResponse(ExperienceCreate):
    id: UUID
    profile_id: UUID

    model_config = ConfigDict(from_attributes=True)

class EducationCreate(BaseModel):
    degree: str
    field_of_study: Optional[str] = None
    institution: str
    country: str
    graduation_year: Optional[int] = None
    is_attested: bool = False

class EducationResponse(EducationCreate):
    id: UUID
    profile_id: UUID

    model_config = ConfigDict(from_attributes=True)

class SkillCreate(BaseModel):
    skill_name: str
    years_of_experience: float = 1.0
    is_verified: bool = False

class SkillResponse(SkillCreate):
    id: UUID
    profile_id: UUID

    model_config = ConfigDict(from_attributes=True)

class CandidateProfileCreate(BaseModel):
    target_job_title: str
    current_resident_country: str
    current_city: str
    nationality: str
    total_experience_years: float = 0.0
    gcc_experience_years: float = 0.0
    is_actively_looking: bool = True
    notice_period_days: int = 30
    relocation_status: str = "Ready for Relocation"
    expected_salary_min: Optional[float] = None
    expected_salary_currency: str = "SAR"
    bio: Optional[str] = None
    linkedin_url: Optional[str] = None

class CandidateProfileUpdate(BaseModel):
    target_job_title: Optional[str] = None
    current_resident_country: Optional[str] = None
    current_city: Optional[str] = None
    nationality: Optional[str] = None
    total_experience_years: Optional[float] = None
    gcc_experience_years: Optional[float] = None
    is_actively_looking: Optional[bool] = None
    notice_period_days: Optional[int] = None
    relocation_status: Optional[str] = None
    expected_salary_min: Optional[float] = None
    expected_salary_currency: Optional[str] = None
    bio: Optional[str] = None
    linkedin_url: Optional[str] = None

class CandidateProfileResponse(BaseModel):
    id: UUID
    user_id: UUID
    target_job_title: str
    current_resident_country: str
    current_city: str
    nationality: str
    total_experience_years: float
    gcc_experience_years: float
    relocation_readiness_score: int
    is_actively_looking: bool
    is_gcc_verified: bool
    notice_period_days: int
    relocation_status: str
    expected_salary_min: Optional[float] = None
    expected_salary_currency: str
    bio: Optional[str] = None
    linkedin_url: Optional[str] = None
    created_at: datetime
    updated_at: datetime
    experiences: List[ExperienceResponse] = []
    educations: List[EducationResponse] = []
    skills: List[SkillResponse] = []

    model_config = ConfigDict(from_attributes=True)

class ReadinessScoreResponse(BaseModel):
    relocation_readiness_score: int
    breakdown: dict
    recommendations: List[str]
