from typing import Optional
from uuid import UUID
from datetime import datetime
from pydantic import BaseModel, EmailStr, Field, ConfigDict

class UserRegisterRequest(BaseModel):
    email: EmailStr
    password: str = Field(..., min_length=6)
    full_name: str = Field(..., min_length=2)
    phone_country_code: Optional[str] = "+966" # GCC default
    phone_number: Optional[str] = None
    role: Optional[str] = "candidate"
    preferred_language: Optional[str] = "en"

class UserLoginRequest(BaseModel):
    email: EmailStr
    password: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    expires_in: int
    user_id: UUID
    role: str
    full_name: str
    email: str
    avatar_url: Optional[str] = None

class UserResponse(BaseModel):
    id: UUID
    email: str
    phone_country_code: str
    phone_number: str
    full_name: str
    avatar_url: Optional[str] = None
    role: str
    preferred_language: str
    is_phone_verified: bool
    is_active: bool
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
