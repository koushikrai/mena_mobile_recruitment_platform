from fastapi import APIRouter
from app.api.v1 import auth, candidates, jobs, applications, vault, compliance

api_router = APIRouter()

api_router.include_router(auth.router)
api_router.include_router(candidates.router)
api_router.include_router(jobs.router)
api_router.include_router(applications.router)
api_router.include_router(vault.router)
api_router.include_router(compliance.router)
