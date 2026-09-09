import os
from typing import List
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    PROJECT_NAME: str = "MENA Mobile Recruitment Platform API"
    VERSION: str = "1.0.0"
    API_V1_STR: str = "/api/v1"
    
    # Database
    # Default points to Neon Postgres or can be overridden by .env
    DATABASE_URL: str = os.getenv(
        "DATABASE_URL", 
        "postgresql+asyncpg://neondb_owner:npg_Z6tV0BPjcNnd@ep-gentle-violet-aeon10sh-pooler.c-2.us-east-2.aws.neon.tech/neondb?ssl=require"
    )
    
    # JWT Security
    SECRET_KEY: str = os.getenv("SECRET_KEY", "mena-recruitment-super-secret-production-key-2026-xyz-987")
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 7 days
    
    # AI CV Parsing
    GEMINI_API_KEY: str = os.getenv("GEMINI_API_KEY", "")
    
    # CORS
    CORS_ORIGINS: List[str] = ["*"]
    
    # File Storage
    UPLOAD_DIR: str = os.getenv("UPLOAD_DIR", "uploads")
    
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore"
    )

settings = Settings()
