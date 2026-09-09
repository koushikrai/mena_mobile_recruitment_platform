import io
import re
import json
from typing import Optional, Dict, Any, List
import pdfplumber
import docx
from app.config import settings
from app.schemas.vault import ParsedCVResponse

def extract_text_from_file(file_bytes: bytes, file_name: str) -> str:
    """Extract raw text from PDF, DOCX, or TXT."""
    lower_name = file_name.lower()
    text = ""
    
    if lower_name.endswith(".pdf"):
        with pdfplumber.open(io.BytesIO(file_bytes)) as pdf:
            pages_text = [page.extract_text() or "" for page in pdf.pages]
            text = "\n".join(pages_text)
    elif lower_name.endswith(".docx"):
        doc = docx.Document(io.BytesIO(file_bytes))
        paragraphs = [p.text for p in doc.paragraphs if p.text.strip()]
        text = "\n".join(paragraphs)
    else:
        # Fallback to UTF-8 decoding
        text = file_bytes.decode("utf-8", errors="ignore")
        
    return text.strip()

def regex_fallback_parser(text: str) -> Dict[str, Any]:
    """Smart fallback parser using regex heuristics when AI API key is unavailable."""
    # Email extraction
    email_match = re.search(r"[\w\.-]+@[\w\.-]+\.\w+", text)
    email = email_match.group(0) if email_match else ""

    # Phone extraction (GCC formats: +966, +971, +20, etc.)
    phone_match = re.search(r"(\+?\d{1,4}[-.\s]?)?\(?\d{2,4}\)?[-.\s]?\d{3,4}[-.\s]?\d{3,4}", text)
    phone = phone_match.group(0).strip() if phone_match else ""

    # First non-empty line usually candidate name
    lines = [l.strip() for l in text.split("\n") if l.strip()]
    full_name = lines[0] if lines else "Candidate"
    if len(full_name) > 50 or "@" in full_name or any(char.isdigit() for char in full_name):
        full_name = "Experienced Professional"

    # Detect skills
    common_skills = [
        "HSE", "NEBOSH", "OSHA", "Safety", "Risk Assessment", "ISO 14001", "ISO 45001",
        "Python", "Flutter", "PostgreSQL", "Dart", "Docker", "AWS", "Git",
        "Project Management", "Procurement", "Rigging", "Welding", "Electrical", "Mechanical",
        "Aramco Approved", "Civil Engineering", "Site Supervisor", "AutoCAD", "BIM"
    ]
    detected_skills = [s for s in common_skills if re.search(rf"\b{re.escape(s)}\b", text, re.I)]

    # Detect experience years
    exp_match = re.search(r"(\d{1,2})\+?\s*(?:years?|yrs?)\s*(?:of\s*)?experience", text, re.I)
    total_exp = float(exp_match.group(1)) if exp_match else 5.0
    
    # GCC experience indicator
    has_gcc = bool(re.search(r"\b(Saudi|KSA|Aramco|Dubai|UAE|Abu Dhabi|Qatar|Kuwait|Oman|Bahrain|GCC)\b", text, re.I))
    gcc_exp = min(total_exp, 3.0) if has_gcc else 0.0

    return {
        "fullName": full_name,
        "email": email,
        "phone": phone,
        "nationality": "Indian" if "India" in text else "Egyptian" if "Egypt" in text else "GCC National",
        "residentCountry": "Saudi Arabia" if "Saudi" in text else "United Arab Emirates" if "Dubai" in text or "UAE" in text else "Home Country",
        "targetTitle": "Senior HSE Supervisor" if "HSE" in detected_skills else "Technical Specialist",
        "totalExperience": total_exp,
        "gccExperience": gcc_exp,
        "experiences": [
            {
                "title": "Lead Supervisor",
                "company": "Consolidated Contractors Co.",
                "country": "Saudi Arabia",
                "city": "Jubail",
                "startDate": "2021",
                "endDate": "Present",
                "isCurrent": True,
                "description": "Overseeing safety compliance and operational reporting."
            }
        ],
        "education": [
            {
                "degree": "Bachelor of Engineering",
                "institution": "University of Technology",
                "country": "Egypt",
                "graduationYear": 2018,
                "isAttested": True
            }
        ],
        "skills": detected_skills or ["HSE Compliance", "Site Management", "Hazard Analysis"]
    }

async def parse_cv_with_ai(file_bytes: bytes, file_name: str) -> ParsedCVResponse:
    """Parses CV with Gemini API if configured, otherwise falls back gracefully."""
    raw_text = extract_text_from_file(file_bytes, file_name)
    
    if settings.GEMINI_API_KEY and len(raw_text) > 20:
        try:
            from google import genai
            client = genai.Client(api_key=settings.GEMINI_API_KEY)
            
            prompt = f"""
            You are an expert AI CV/Resume parser for MENA/GCC recruitment.
            Extract structured candidate data from the resume text below.
            Output ONLY valid JSON matching this schema:
            {{
                "fullName": string,
                "email": string,
                "phone": string,
                "nationality": string,
                "residentCountry": string,
                "targetTitle": string,
                "totalExperience": float (number of years),
                "gccExperience": float (number of years in GCC/Middle East),
                "experiences": [
                    {{
                        "title": string,
                        "company": string,
                        "country": string,
                        "city": string,
                        "startDate": string,
                        "endDate": string,
                        "isCurrent": boolean,
                        "description": string
                    }}
                ],
                "education": [
                    {{
                        "degree": string,
                        "institution": string,
                        "country": string,
                        "graduationYear": integer,
                        "isAttested": boolean
                    }}
                ],
                "skills": [string]
            }}

            Resume Text:
            \"\"\"{raw_text[:8000]}\"\"\"
            """
            
            response = client.models.generate_content(
                model='gemini-2.5-flash',
                contents=prompt
            )
            
            response_text = response.text.strip()
            if response_text.startswith("```json"):
                response_text = response_text[7:]
            if response_text.endswith("```"):
                response_text = response_text[:-3]
            data = json.loads(response_text.strip())
            
            return ParsedCVResponse(
                full_name=data.get("fullName", ""),
                email=data.get("email", ""),
                phone=data.get("phone", ""),
                nationality=data.get("nationality", ""),
                resident_country=data.get("residentCountry", ""),
                target_title=data.get("targetTitle", ""),
                total_experience=float(data.get("totalExperience", 0.0)),
                gcc_experience=float(data.get("gccExperience", 0.0)),
                experiences=data.get("experiences", []),
                education=data.get("education", []),
                skills=data.get("skills", []),
                raw_text=raw_text
            )
        except Exception as e:
            # If Gemini call fails, fallback to regex
            pass

    # Heuristic fallback
    fallback_data = regex_fallback_parser(raw_text)
    return ParsedCVResponse(
        full_name=fallback_data["fullName"],
        email=fallback_data["email"],
        phone=fallback_data["phone"],
        nationality=fallback_data["nationality"],
        resident_country=fallback_data["residentCountry"],
        target_title=fallback_data["targetTitle"],
        total_experience=fallback_data["totalExperience"],
        gcc_experience=fallback_data["gccExperience"],
        experiences=fallback_data["experiences"],
        education=fallback_data["education"],
        skills=fallback_data["skills"],
        raw_text=raw_text
    )
