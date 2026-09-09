import os
import uuid
from pathlib import Path
from app.config import settings

def save_uploaded_file(file_bytes: bytes, original_filename: str) -> tuple[str, str, int]:
    """
    Saves file to local uploads directory (or S3 in production).
    Returns (saved_filename, file_url, size_bytes).
    """
    upload_path = Path(settings.UPLOAD_DIR)
    upload_path.mkdir(parents=True, exist_ok=True)

    ext = Path(original_filename).suffix.lower()
    unique_filename = f"{uuid.uuid4()}{ext}"
    destination = upload_path / unique_filename

    with open(destination, "wb") as f:
        f.write(file_bytes)

    # In production, this can be an S3 or Cloudflare R2 presigned/public URL
    file_url = f"/static/uploads/{unique_filename}"
    size_bytes = len(file_bytes)

    return unique_filename, file_url, size_bytes
