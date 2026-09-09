import uuid
from datetime import datetime
from sqlalchemy import Column, String, Boolean, DateTime, Integer, Numeric, Text, ForeignKey, JSON
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.database import Base

class Company(Base):
    __tablename__ = "companies"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    name = Column(String(200), nullable=False)
    country_code = Column(String(5), nullable=False) # 'KSA', 'UAE', 'QAT', 'KWT', 'OMN', 'BHR'
    city = Column(String(100), nullable=False)
    logo_url = Column(String, nullable=True)
    commercial_reg_number = Column(String(100), nullable=True)
    is_mofa_registered = Column(Boolean, default=False, nullable=False)
    is_mhrsd_licensed = Column(Boolean, default=False, nullable=False)
    is_verified_employer = Column(Boolean, default=True, nullable=False)
    recruiter_whatsapp = Column(String(30), nullable=True)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)

    jobs = relationship("Job", back_populates="company", cascade="all, delete-orphan")
    walkin_drives = relationship("WalkinDrive", back_populates="company", cascade="all, delete-orphan")


class Job(Base):
    __tablename__ = "jobs"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    company_id = Column(UUID(as_uuid=True), ForeignKey("companies.id", ondelete="CASCADE"), nullable=False, index=True)
    reference_code = Column(String(50), nullable=False, index=True) # e.g. 'PG-HSE-908'
    title = Column(String(200), nullable=False, index=True)
    sector = Column(String(100), nullable=False, index=True) # e.g. 'Oil & Gas', 'Healthcare'
    country_code = Column(String(5), nullable=False, index=True)
    city = Column(String(100), nullable=False)
    salary_min = Column(Numeric(12, 2), nullable=False)
    salary_max = Column(Numeric(12, 2), nullable=False)
    salary_currency = Column(String(10), default="SAR", nullable=False)
    visa_status = Column(String(100), default="Free Visa & Work Permit Provided", nullable=False)
    rotation_schedule = Column(String(50), nullable=True) # e.g. '28/28 On/Off', 'Annual 30-Day Leave'
    required_experience_years = Column(Numeric(4, 1), default=3.0, nullable=False)
    required_skills = Column(JSON, default=list, nullable=False)
    relocation_benefits = Column(JSON, default=list, nullable=False) # Housing, Flights, Health Insurance
    description = Column(Text, nullable=False)
    zero_recruitment_fee_guarantee = Column(Boolean, default=True, nullable=False)
    is_urgent = Column(Boolean, default=False, nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime(timezone=True), default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    company = relationship("Company", back_populates="jobs")
    bookmarks = relationship("JobBookmark", back_populates="job", cascade="all, delete-orphan")
    applications = relationship("JobApplication", back_populates="job", cascade="all, delete-orphan")


class JobBookmark(Base):
    __tablename__ = "job_bookmarks"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    job_id = Column(UUID(as_uuid=True), ForeignKey("jobs.id", ondelete="CASCADE"), nullable=False, index=True)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="bookmarks")
    job = relationship("Job", back_populates="bookmarks")


class WalkinDrive(Base):
    __tablename__ = "walkin_drives"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    company_id = Column(UUID(as_uuid=True), ForeignKey("companies.id", ondelete="CASCADE"), nullable=False)
    title = Column(String(250), nullable=False)
    country_code = Column(String(5), nullable=False)
    city = Column(String(100), nullable=False)
    venue_name = Column(String(200), nullable=False)
    venue_address = Column(String(300), nullable=False)
    start_date = Column(DateTime(timezone=True), nullable=False)
    end_date = Column(DateTime(timezone=True), nullable=False)
    time_slots = Column(JSON, default=list, nullable=False) # e.g. ['09:00 - 11:00 AM', '02:00 - 04:00 PM']
    available_quotas = Column(Integer, default=1000, nullable=False)
    registered_count = Column(Integer, default=0, nullable=False)
    qr_code_prefix = Column(String(20), default="WALKIN-", nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)

    company = relationship("Company", back_populates="walkin_drives")
    registrations = relationship("WalkinRegistration", back_populates="drive", cascade="all, delete-orphan")


class WalkinRegistration(Base):
    __tablename__ = "walkin_registrations"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    drive_id = Column(UUID(as_uuid=True), ForeignKey("walkin_drives.id", ondelete="CASCADE"), nullable=False, index=True)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    time_slot = Column(String(50), nullable=False)
    qr_pass_code = Column(String(100), unique=True, nullable=False)
    status = Column(String(30), default="registered", nullable=False) # registered, attended, cancelled
    registered_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)

    drive = relationship("WalkinDrive", back_populates="registrations")
    user = relationship("User", back_populates="walkin_registrations")
