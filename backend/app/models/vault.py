import uuid
from datetime import datetime, date
from sqlalchemy import Column, String, Boolean, DateTime, Date, BigInteger, Numeric, Text, ForeignKey, JSON
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.database import Base

class DocumentVault(Base):
    __tablename__ = "document_vault"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    document_type = Column(String(20), nullable=False) # 'passport' or 'cv_resume'
    file_name = Column(String(255), nullable=False)
    file_url = Column(Text, nullable=False)
    file_size_bytes = Column(BigInteger, nullable=True)
    mime_type = Column(String(100), nullable=False)
    upload_source = Column(String(50), default="manual", nullable=False) # 'manual', 'whatsapp', 'linkedin'

    # Passport-specific fields
    passport_number = Column(String(50), nullable=True, index=True)
    issuing_country = Column(String(100), nullable=True)
    country_code_icao = Column(String(5), nullable=True) # e.g. 'EGY', 'IND', 'PAK'
    passport_nationality = Column(String(100), nullable=True)
    surname = Column(String(100), nullable=True)
    given_names = Column(String(150), nullable=True)
    date_of_birth = Column(Date, nullable=True)
    gender = Column(String(10), nullable=True)
    issue_date = Column(Date, nullable=True)
    expiry_date = Column(Date, nullable=True, index=True)
    mrz_raw_line1 = Column(String(44), nullable=True)
    mrz_raw_line2 = Column(String(44), nullable=True)
    is_mrz_checksum_valid = Column(Boolean, default=True, nullable=True)
    has_six_months_validity = Column(Boolean, default=True, nullable=True)
    face_id_match_score = Column(Numeric(5, 2), default=98.0, nullable=True)

    # CV / Resume specific fields
    extracted_full_text = Column(Text, nullable=True)
    parsed_data = Column(JSON, default=dict, nullable=False)
    is_primary_cv = Column(Boolean, default=True, nullable=False)

    # Verification status
    is_verified = Column(Boolean, default=False, nullable=False)
    verification_status = Column(String(20), default="pending", nullable=False) # 'pending', 'verified', 'rejected', 'expired'
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime(timezone=True), default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="documents")
    reminders = relationship("ComplianceReminder", back_populates="document", cascade="all, delete-orphan")


class ComplianceReminder(Base):
    __tablename__ = "compliance_reminders"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    document_id = Column(UUID(as_uuid=True), ForeignKey("document_vault.id", ondelete="CASCADE"), nullable=True)
    reminder_type = Column(String(50), nullable=False) # 'passport_180_days', 'passport_90_days', 'visa_expiry'
    due_date = Column(Date, nullable=False)
    message = Column(String(255), nullable=False)
    is_resolved = Column(Boolean, default=False, nullable=False)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="reminders")
    document = relationship("DocumentVault", back_populates="reminders")
