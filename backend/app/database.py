import ssl
from typing import AsyncGenerator
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession
from sqlalchemy.orm import declarative_base
from app.config import settings

# Adjust URL for asyncpg if needed
db_url = settings.DATABASE_URL
if db_url.startswith("postgresql://"):
    db_url = db_url.replace("postgresql://", "postgresql+asyncpg://", 1)

# Remove sslmode query param from URL if present for asyncpg compatibility, and pass connect_args
connect_args = {}
if "neon.tech" in db_url or "sslmode=require" in db_url or "ssl=require" in db_url:
    # Clean query parameters for asyncpg
    base_url = db_url.split("?")[0]
    db_url = base_url
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    connect_args = {
        "ssl": ctx,
        "statement_cache_size": 0,
        "prepared_statement_cache_size": 0
    }

from sqlalchemy.pool import NullPool

engine = create_async_engine(
    db_url,
    echo=False,
    future=True,
    connect_args=connect_args,
    poolclass=NullPool
)

AsyncSessionLocal = async_sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autocommit=False,
    autoflush=False
)

Base = declarative_base()

async def get_db() -> AsyncGenerator[AsyncSession, None]:
    async with AsyncSessionLocal() as session:
        try:
            yield session
        finally:
            await session.close()
