import pytest
from app.services.cv_parser_service import regex_fallback_parser, extract_text_from_file

def test_regex_fallback_parser():
    sample_cv = """
    Tariq Mahmoud Al-Masri
    Email: tariq.hse@gmail.com
    Phone: +966 55 987 6543
    Location: Jubail, Saudi Arabia
    
    Professional Summary:
    Certified HSE Engineer with 8+ years of experience across Saudi Aramco and SABIC turnaround projects.
    
    Key Skills:
    NEBOSH, OSHA, Risk Assessment, PTW Mastery, ISO 45001, Safety Auditing.
    """
    
    parsed = regex_fallback_parser(sample_cv)
    assert parsed["email"] == "tariq.hse@gmail.com"
    assert "966" in parsed["phone"]
    assert parsed["totalExperience"] == 8.0
    assert parsed["gccExperience"] == 3.0
    assert "HSE" in parsed["skills"] or "NEBOSH" in parsed["skills"]
    assert "Saudi Arabia" in parsed["residentCountry"]

def test_extract_text_plain():
    text_bytes = b"Sample plain text resume content for testing."
    result = extract_text_from_file(text_bytes, "test.txt")
    assert "Sample plain text" in result
