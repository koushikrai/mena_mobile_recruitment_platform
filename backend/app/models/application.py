import uuid
from datetime import datetime
from sqlalchemy import Column, String, DateTime, ForeignKey, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.database import Base

class JobApplication(Base):
    __tablename__ = "job_applications"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    job_id = Column(UUID(as_uuid=True), ForeignKey("jobs.id", ondelete="CASCADE"), nullable=False, index=True)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    status = Column(String(50), default="applied", nullable=False) 
    # Stages: 'applied', 'screening', 'interview', 'offer', 'visa_processing', 'flight'
    cv_document_id = Column(UUID(as_uuid=True), nullable=True)
    passport_document_id = Column(UUID(as_uuid=True), nullable=True)
    applied_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime(timezone=True), default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="applications")
    job = relationship("Job", back_populates="applications")
    timeline_events = relationship("ApplicationTimelineEvent", back_populates="application", cascade="all, delete-orphan")


class ApplicationTimelineEvent(Base):
    __tablename__ = "application_timeline_events"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    application_id = Column(UUID(as_uuid=True), ForeignKey("job_applications.id", ondelete="CASCADE"), nullable=False, index=True)
    stage = Column(String(50), nullable=False) # 'applied', 'screening', 'interview', 'offer', 'visa_processing', 'flight'
    title = Column(String(200), nullable=False)
    description = Column(Text, nullable=True)
    timestamp = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)

    application = relationship("JobApplication", back_populates="timeline_events")
