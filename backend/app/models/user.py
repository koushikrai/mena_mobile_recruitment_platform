import uuid
from datetime import datetime
from sqlalchemy import Column, String, Boolean, DateTime
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = Column(String(255), unique=True, nullable=False, index=True)
    phone_country_code = Column(String(8), nullable=False)
    phone_number = Column(String(20), unique=True, nullable=False, index=True)
    password_hash = Column(String(255), nullable=False)
    full_name = Column(String(150), nullable=False)
    avatar_url = Column(String, nullable=True)
    role = Column(String(20), nullable=False, default="candidate") # candidate, employer, admin
    preferred_language = Column(String(5), nullable=False, default="en") # 'en' or 'ar'
    is_phone_verified = Column(Boolean, nullable=False, default=False)
    is_active = Column(Boolean, nullable=False, default=True)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime(timezone=True), default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    profile = relationship("CandidateProfile", back_populates="user", uselist=False, cascade="all, delete-orphan")
    documents = relationship("DocumentVault", back_populates="user", cascade="all, delete-orphan")
    bookmarks = relationship("JobBookmark", back_populates="user", cascade="all, delete-orphan")
    applications = relationship("JobApplication", back_populates="user", cascade="all, delete-orphan")
    walkin_registrations = relationship("WalkinRegistration", back_populates="user", cascade="all, delete-orphan")
    reminders = relationship("ComplianceReminder", back_populates="user", cascade="all, delete-orphan")
