from datetime import date, datetime, timedelta
from typing import Tuple, List, Optional
from app.schemas.vault import MRZVerifyResponse

# ICAO 9303 Character weights
WEIGHTS = [7, 3, 1]

def char_to_value(c: str) -> int:
    if c == '<':
        return 0
    if c.isdigit():
        return int(c)
    if 'A' <= c.upper() <= 'Z':
        return ord(c.upper()) - 55
    return 0

def calculate_check_digit(data: str) -> int:
    total = 0
    for idx, char in enumerate(data):
        weight = WEIGHTS[idx % 3]
        total += char_to_value(char) * weight
    return total % 10

def parse_date(date_str: str, is_expiry: bool = False) -> Optional[date]:
    """Parse YYMMDD into datetime.date."""
    if len(date_str) != 6 or not date_str.isdigit():
        return None
    yy = int(date_str[0:2])
    mm = int(date_str[2:4])
    dd = int(date_str[4:6])
    
    current_year = date.today().year % 100
    if is_expiry:
        # Expiry date is usually in the future
        year = 2000 + yy if yy <= current_year + 50 else 1900 + yy
    else:
        # Birth date is usually in the past
        year = 2000 + yy if yy <= current_year else 1900 + yy
        
    try:
        return date(year, mm, dd)
    except ValueError:
        return None

def parse_td3_mrz(line1: str, line2: str) -> MRZVerifyResponse:
    """
    Parses ICAO Doc 9303 TD3 2-line Machine Readable Zone (44 chars each).
    """
    errors: List[str] = []
    line1 = line1.strip().upper()
    line2 = line2.strip().upper()

    if len(line1) != 44:
        errors.append(f"Line 1 length is {len(line1)}, expected 44")
    if len(line2) != 44:
        errors.append(f"Line 2 length is {len(line2)}, expected 44")

    if errors:
        return MRZVerifyResponse(
            is_valid=False,
            document_type="passport",
            issuing_country="",
            country_code_icao="",
            surname="",
            given_names="",
            passport_number="",
            nationality="",
            has_six_months_validity=False,
            days_until_expiry=0,
            validation_errors=errors
        )

    # Line 1: P<[ISS(3)][NAME...]
    doc_type = line1[0:2].replace('<', '')
    issuing_country = line1[2:5].replace('<', '')
    name_field = line1[5:44]
    
    parts = name_field.split('<<')
    surname = parts[0].replace('<', ' ').strip()
    given_names = parts[1].replace('<', ' ').strip() if len(parts) > 1 else ""

    # Line 2:
    # 0-9: Passport number (9 chars)
    # 9: Passport number check digit
    # 10-13: Nationality (3 chars)
    # 13-19: DOB (6 chars)
    # 19: DOB check digit
    # 20: Sex (1 char)
    # 21-27: Expiry date (6 chars)
    # 27: Expiry check digit
    passport_num_raw = line2[0:9]
    passport_num_clean = passport_num_raw.replace('<', '').strip()
    passport_chk = line2[9]
    
    # Check digits (recorded in errors if mismatch)
    checksum_errors: List[str] = []
    if passport_chk.isdigit():
        expected_chk = calculate_check_digit(passport_num_raw)
        if int(passport_chk) != expected_chk:
            checksum_errors.append(f"Passport check digit mismatch: got {passport_chk}, expected {expected_chk}")

    nationality = line2[10:13].replace('<', '').strip()
    
    dob_raw = line2[13:19]
    dob_chk = line2[19]
    if dob_chk.isdigit() and calculate_check_digit(dob_raw) != int(dob_chk):
        checksum_errors.append("Date of birth checksum mismatch")
    dob = parse_date(dob_raw, is_expiry=False)

    sex = line2[20]
    gender = "M" if sex == "M" else "F" if sex == "F" else "Unspecified"

    expiry_raw = line2[21:27]
    expiry_chk = line2[27]
    if expiry_chk.isdigit() and calculate_check_digit(expiry_raw) != int(expiry_chk):
        checksum_errors.append("Expiry date checksum mismatch")
    expiry = parse_date(expiry_raw, is_expiry=True)

    # 6-month validity calculation (GCC Border Regulatory requirement: >= 180 days from today)
    today = date.today()
    has_six_months = False
    days_until_expiry = 0
    if expiry:
        days_until_expiry = (expiry - today).days
        has_six_months = days_until_expiry >= 180
        if not has_six_months:
            errors.append(f"Passport has {days_until_expiry} days validity remaining. GCC rules require at least 180 days (6 months).")
    else:
        errors.append("Invalid expiry date format")

    all_errors = errors + checksum_errors
    # Valid if structural fields and dates parsed, and has minimum validity
    is_valid = (len(errors) == 0) and bool(expiry and dob and passport_num_clean)

    return MRZVerifyResponse(
        is_valid=is_valid,
        document_type="passport" if doc_type.startswith("P") else doc_type,
        issuing_country=issuing_country,
        country_code_icao=issuing_country,
        surname=surname,
        given_names=given_names,
        passport_number=passport_num_clean,
        nationality=nationality,
        date_of_birth=dob,
        gender=gender,
        expiry_date=expiry,
        has_six_months_validity=has_six_months,
        days_until_expiry=days_until_expiry,
        validation_errors=all_errors
    )
