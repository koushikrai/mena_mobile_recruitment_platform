import uuid
from datetime import datetime
from sqlalchemy import Column, String, Boolean, DateTime, Integer, Numeric, Text, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.database import Base

class CandidateProfile(Base):
    __tablename__ = "candidate_profiles"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False, index=True)
    target_job_title = Column(String(150), nullable=False)
    current_resident_country = Column(String(100), nullable=False)
    current_city = Column(String(100), nullable=False)
    nationality = Column(String(100), nullable=False)
    total_experience_years = Column(Numeric(4, 1), default=0.0, nullable=False)
    gcc_experience_years = Column(Numeric(4, 1), default=0.0, nullable=False)
    relocation_readiness_score = Column(Integer, default=0, nullable=False, index=True)
    is_actively_looking = Column(Boolean, default=True, nullable=False)
    is_gcc_verified = Column(Boolean, default=False, nullable=False)
    notice_period_days = Column(Integer, default=30, nullable=False)
    relocation_status = Column(String(100), default="Ready for Relocation", nullable=False)
    expected_salary_min = Column(Numeric(12, 2), nullable=True)
    expected_salary_currency = Column(String(10), default="SAR", nullable=False)
    bio = Column(Text, nullable=True)
    linkedin_url = Column(String(255), nullable=True)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime(timezone=True), default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    user = relationship("User", back_populates="profile")
    experiences = relationship("CandidateExperience", back_populates="profile", cascade="all, delete-orphan")
    educations = relationship("CandidateEducation", back_populates="profile", cascade="all, delete-orphan")
    skills = relationship("CandidateSkill", back_populates="profile", cascade="all, delete-orphan")


class CandidateExperience(Base):
    __tablename__ = "candidate_experiences"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    profile_id = Column(UUID(as_uuid=True), ForeignKey("candidate_profiles.id", ondelete="CASCADE"), nullable=False, index=True)
    company = Column(String(150), nullable=False)
    title = Column(String(150), nullable=False)
    country = Column(String(100), nullable=False)
    city = Column(String(100), nullable=True)
    start_date = Column(String(50), nullable=False)
    end_date = Column(String(50), nullable=True)
    is_current = Column(Boolean, default=False, nullable=False)
    description = Column(Text, nullable=True)

    profile = relationship("CandidateProfile", back_populates="experiences")


class CandidateEducation(Base):
    __tablename__ = "candidate_educations"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    profile_id = Column(UUID(as_uuid=True), ForeignKey("candidate_profiles.id", ondelete="CASCADE"), nullable=False, index=True)
    degree = Column(String(150), nullable=False)
    field_of_study = Column(String(150), nullable=True)
    institution = Column(String(200), nullable=False)
    country = Column(String(100), nullable=False)
    graduation_year = Column(Integer, nullable=True)
    is_attested = Column(Boolean, default=False, nullable=False)

    profile = relationship("CandidateProfile", back_populates="educations")


class CandidateSkill(Base):
    __tablename__ = "candidate_skills"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    profile_id = Column(UUID(as_uuid=True), ForeignKey("candidate_profiles.id", ondelete="CASCADE"), nullable=False, index=True)
    skill_name = Column(String(100), nullable=False)
    years_of_experience = Column(Numeric(4, 1), default=1.0, nullable=False)
    is_verified = Column(Boolean, default=False, nullable=False)

    profile = relationship("CandidateProfile", back_populates="skills")
