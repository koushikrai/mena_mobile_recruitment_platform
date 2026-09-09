from typing import Optional, List
from uuid import UUID
from datetime import datetime
from pydantic import BaseModel, ConfigDict

class TimelineEventResponse(BaseModel):
    id: UUID
    application_id: UUID
    stage: str
    title: str
    description: Optional[str] = None
    timestamp: datetime

    model_config = ConfigDict(from_attributes=True)

class ApplicationCreate(BaseModel):
    job_id: UUID
    cv_document_id: Optional[UUID] = None
    passport_document_id: Optional[UUID] = None

class ApplicationResponse(BaseModel):
    id: UUID
    job_id: UUID
    user_id: UUID
    status: str
    applied_at: datetime
    updated_at: datetime
    job_title: Optional[str] = None
    company_name: Optional[str] = None
    country_code: Optional[str] = None
    city: Optional[str] = None
    salary_range: Optional[str] = None
    timeline_events: List[TimelineEventResponse] = []

    model_config = ConfigDict(from_attributes=True)

class ApplicationStatusUpdate(BaseModel):
    status: str
    title: str
    description: Optional[str] = None
