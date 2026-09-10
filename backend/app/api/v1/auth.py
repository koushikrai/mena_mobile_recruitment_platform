from datetime import timedelta
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.config import settings
from app.database import get_db
from app.models.user import User
from app.models.candidate import CandidateProfile
from app.schemas.auth import UserRegisterRequest, UserLoginRequest, TokenResponse, UserResponse
from app.core.security import verify_password, get_password_hash, create_access_token, get_current_user

router = APIRouter(prefix="/auth", tags=["Authentication"])

@router.post("/register", response_model=TokenResponse, status_code=status.HTTP_201_CREATED)
async def register(req: UserRegisterRequest, db: AsyncSession = Depends(get_db)):
    # Check if email exists
    stmt = select(User).where(User.email == req.email.lower().strip())
    existing = (await db.execute(stmt)).scalar_one_or_none()
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="A user with this email address already exists."
        )

    # Determine phone number
    import random
    phone = req.phone_number.strip() if req.phone_number and req.phone_number.strip() else f"5{random.randint(10000000, 99999999)}"
    phone_code = req.phone_country_code or "+966"

    # Check phone number
    stmt = select(User).where(User.phone_number == phone)
    existing_phone = (await db.execute(stmt)).scalar_one_or_none()
    if existing_phone and req.phone_number:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="A user with this phone number already exists."
        )

    # Create new user
    new_user = User(
        email=req.email.lower().strip(),
        phone_country_code=phone_code,
        phone_number=phone,
        password_hash=get_password_hash(req.password),
        full_name=req.full_name.strip(),
        role=req.role or "candidate",
        preferred_language=req.preferred_language or "en",
        is_phone_verified=True, # Auto-verify for standard flow
        is_active=True
    )
    db.add(new_user)
    await db.flush()

    # Create empty candidate profile if candidate role
    if new_user.role == "candidate":
        profile = CandidateProfile(
            user_id=new_user.id,
            target_job_title="Candidate",
            current_resident_country="Saudi Arabia",
            current_city="Riyadh",
            nationality="GCC Applicant",
            relocation_readiness_score=35
        )
        db.add(profile)

    await db.commit()
    await db.refresh(new_user)

    # Issue JWT token
    access_token = create_access_token(
        data={"sub": str(new_user.id), "role": new_user.role, "email": new_user.email}
    )

    return TokenResponse(
        access_token=access_token,
        token_type="bearer",
        expires_in=settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60,
        user_id=new_user.id,
        role=new_user.role,
        full_name=new_user.full_name,
        email=new_user.email,
        avatar_url=new_user.avatar_url
    )

@router.post("/login", response_model=TokenResponse)
async def login(req: UserLoginRequest, db: AsyncSession = Depends(get_db)):
    stmt = select(User).where(User.email == req.email.lower().strip())
    user = (await db.execute(stmt)).scalar_one_or_none()

    if not user or not verify_password(req.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"}
        )

    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Account is suspended or deactivated"
        )

    access_token = create_access_token(
        data={"sub": str(user.id), "role": user.role, "email": user.email}
    )

    return TokenResponse(
        access_token=access_token,
        token_type="bearer",
        expires_in=settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60,
        user_id=user.id,
        role=user.role,
        full_name=user.full_name,
        email=user.email,
        avatar_url=user.avatar_url
    )

@router.get("/me", response_model=UserResponse)
async def get_me(current_user: User = Depends(get_current_user)):
    return current_user
