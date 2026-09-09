from typing import Optional, List
from uuid import UUID
from datetime import datetime
from pydantic import BaseModel, Field, ConfigDict

class CompanyResponse(BaseModel):
    id: UUID
    name: str
    country_code: str
    city: str
    logo_url: Optional[str] = None
    is_mofa_registered: bool
    is_mhrsd_licensed: bool
    is_verified_employer: bool
    recruiter_whatsapp: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)

class JobResponse(BaseModel):
    id: UUID
    company_id: UUID
    company_name: Optional[str] = None
    company_logo: Optional[str] = None
    reference_code: str
    title: str
    sector: str
    country_code: str
    city: str
    salary_min: float
    salary_max: float
    salary_currency: str
    visa_status: str
    rotation_schedule: Optional[str] = None
    required_experience_years: float
    required_skills: List[str] = []
    relocation_benefits: List[str] = []
    description: str
    zero_recruitment_fee_guarantee: bool
    is_urgent: bool
    is_bookmarked: bool = False
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)

class JobFilterParams(BaseModel):
    search_query: Optional[str] = None
    selected_countries: Optional[List[str]] = None
    sector: Optional[str] = None
    visa_sponsored: Optional[bool] = None
    transferable_iqama: Optional[bool] = None
    min_salary: Optional[float] = None
    currency: Optional[str] = None
    page: int = 1
    page_size: int = 20

class WalkinDriveResponse(BaseModel):
    id: UUID
    company_id: UUID
    company_name: Optional[str] = None
    title: str
    country_code: str
    city: str
    venue_name: str
    venue_address: str
    start_date: datetime
    end_date: datetime
    time_slots: List[str] = []
    available_quotas: int
    registered_count: int
    qr_code_prefix: str
    is_active: bool

    model_config = ConfigDict(from_attributes=True)

class WalkinRegisterRequest(BaseModel):
    time_slot: str

class WalkinRegistrationResponse(BaseModel):
    id: UUID
    drive_id: UUID
    user_id: UUID
    time_slot: str
    qr_pass_code: str
    status: str
    registered_at: datetime

    model_config = ConfigDict(from_attributes=True)
