from typing import Optional, List, Any
from uuid import UUID
from datetime import date, datetime
from pydantic import BaseModel, Field, ConfigDict

class MRZVerifyRequest(BaseModel):
    mrz_raw_line1: str = Field(..., min_length=44, max_length=44)
    mrz_raw_line2: str = Field(..., min_length=44, max_length=44)

class MRZVerifyResponse(BaseModel):
    is_valid: bool
    document_type: str
    issuing_country: str
    country_code_icao: str
    surname: str
    given_names: str
    passport_number: str
    nationality: str
    date_of_birth: Optional[date] = None
    gender: Optional[str] = None
    expiry_date: Optional[date] = None
    has_six_months_validity: bool
    days_until_expiry: int
    validation_errors: List[str] = []

class DocumentVaultResponse(BaseModel):
    id: UUID
    user_id: UUID
    document_type: str # 'passport' or 'cv_resume'
    file_name: str
    file_url: str
    file_size_bytes: Optional[int] = None
    mime_type: str
    upload_source: str
    
    # Passport fields
    passport_number: Optional[str] = None
    issuing_country: Optional[str] = None
    country_code_icao: Optional[str] = None
    passport_nationality: Optional[str] = None
    surname: Optional[str] = None
    given_names: Optional[str] = None
    expiry_date: Optional[date] = None
    has_six_months_validity: Optional[bool] = None
    face_id_match_score: Optional[float] = None
    
    # CV fields
    is_primary_cv: bool = False
    parsed_data: Optional[dict] = None
    
    is_verified: bool
    verification_status: str
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)

class ParsedCVResponse(BaseModel):
    full_name: str
    email: str
    phone: str
    nationality: str
    resident_country: str
    target_title: str
    total_experience: float
    gcc_experience: float
    experiences: List[dict] = []
    education: List[dict] = []
    skills: List[str] = []
    raw_text: Optional[str] = None

class ComplianceReminderResponse(BaseModel):
    id: UUID
    reminder_type: str
    due_date: date
    message: str
    is_resolved: bool
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
