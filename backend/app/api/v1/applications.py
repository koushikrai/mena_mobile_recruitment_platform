from uuid import UUID
from datetime import datetime
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select, and_
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.models.user import User
from app.models.job import Job
from app.models.application import JobApplication, ApplicationTimelineEvent
from app.schemas.application import (
    ApplicationCreate,
    ApplicationResponse,
    ApplicationStatusUpdate,
    TimelineEventResponse
)
from app.core.security import get_current_user

router = APIRouter(prefix="/applications", tags=["Relocation Pipeline & Applications"])

@router.get("", response_model=List[ApplicationResponse])
async def list_my_applications(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    stmt = (
        select(JobApplication)
        .where(JobApplication.user_id == current_user.id)
        .options(
            selectinload(JobApplication.job).selectinload(Job.company),
            selectinload(JobApplication.timeline_events)
        )
        .order_by(JobApplication.applied_at.desc())
    )
    apps = (await db.execute(stmt)).scalars().all()

    response = []
    for app in apps:
        salary_str = f"{app.job.salary_currency} {int(app.job.salary_min):,} - {int(app.job.salary_max):,}" if app.job else ""
        resp = ApplicationResponse(
            id=app.id,
            job_id=app.job_id,
            user_id=app.user_id,
            status=app.status,
            applied_at=app.applied_at,
            updated_at=app.updated_at,
            job_title=app.job.title if app.job else None,
            company_name=app.job.company.name if app.job and app.job.company else None,
            country_code=app.job.country_code if app.job else None,
            city=app.job.city if app.job else None,
            salary_range=salary_str,
            timeline_events=[
                TimelineEventResponse(
                    id=ev.id,
                    application_id=ev.application_id,
                    stage=ev.stage,
                    title=ev.title,
                    description=ev.description,
                    timestamp=ev.timestamp
                ) for ev in (app.timeline_events or [])
            ]
        )
        response.append(resp)
    return response

@router.post("", response_model=ApplicationResponse, status_code=status.HTTP_201_CREATED)
async def submit_application(
    req: ApplicationCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    # Verify job exists
    job_stmt = select(Job).options(selectinload(Job.company)).where(Job.id == req.job_id)
    job = (await db.execute(job_stmt)).scalar_one_or_none()
    if not job:
        raise HTTPException(status_code=404, detail="Job vacancy not found")

    # Check if already applied
    existing_stmt = select(JobApplication).where(
        and_(JobApplication.job_id == req.job_id, JobApplication.user_id == current_user.id)
    )
    existing = (await db.execute(existing_stmt)).scalar_one_or_none()
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="You have already submitted an application for this vacancy."
        )

    # Create application
    new_app = JobApplication(
        job_id=req.job_id,
        user_id=current_user.id,
        status="applied",
        cv_document_id=req.cv_document_id,
        passport_document_id=req.passport_document_id
    )
    db.add(new_app)
    await db.flush()

    # Initial timeline event
    event = ApplicationTimelineEvent(
        application_id=new_app.id,
        stage="applied",
        title="Application Submitted",
        description=f"Direct application submitted for {job.title} at {job.company.name}."
    )
    db.add(event)
    await db.commit()
    await db.refresh(new_app)

    salary_str = f"{job.salary_currency} {int(job.salary_min):,} - {int(job.salary_max):,}"
    return ApplicationResponse(
        id=new_app.id,
        job_id=new_app.job_id,
        user_id=new_app.user_id,
        status=new_app.status,
        applied_at=new_app.applied_at,
        updated_at=new_app.updated_at,
        job_title=job.title,
        company_name=job.company.name,
        country_code=job.country_code,
        city=job.city,
        salary_range=salary_str,
        timeline_events=[
            TimelineEventResponse(
                id=event.id,
                application_id=event.application_id,
                stage=event.stage,
                title=event.title,
                description=event.description,
                timestamp=event.timestamp
            )
        ]
    )

@router.post("/{app_id}/stage", response_model=ApplicationResponse)
async def update_pipeline_stage(
    app_id: UUID,
    req: ApplicationStatusUpdate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    stmt = (
        select(JobApplication)
        .where(JobApplication.id == app_id)
        .options(
            selectinload(JobApplication.job).selectinload(Job.company),
            selectinload(JobApplication.timeline_events)
        )
    )
    app = (await db.execute(stmt)).scalar_one_or_none()
    if not app:
        raise HTTPException(status_code=404, detail="Application not found")

    app.status = req.status
    app.updated_at = datetime.utcnow()

    new_event = ApplicationTimelineEvent(
        application_id=app.id,
        stage=req.status,
        title=req.title,
        description=req.description
    )
    db.add(new_event)
    await db.commit()
    await db.refresh(app)

    salary_str = f"{app.job.salary_currency} {int(app.job.salary_min):,} - {int(app.job.salary_max):,}" if app.job else ""
    return ApplicationResponse(
        id=app.id,
        job_id=app.job_id,
        user_id=app.user_id,
        status=app.status,
        applied_at=app.applied_at,
        updated_at=app.updated_at,
        job_title=app.job.title if app.job else None,
        company_name=app.job.company.name if app.job and app.job.company else None,
        country_code=app.job.country_code if app.job else None,
        city=app.job.city if app.job else None,
        salary_range=salary_str,
        timeline_events=[
            TimelineEventResponse(
                id=ev.id,
                application_id=ev.application_id,
                stage=ev.stage,
                title=ev.title,
                description=ev.description,
                timestamp=ev.timestamp
            ) for ev in app.timeline_events
        ]
    )
