from datetime import date, timedelta
from app.services.mrz_service import parse_td3_mrz, calculate_check_digit, char_to_value

def test_char_to_value():
    assert char_to_value('<') == 0
    assert char_to_value('0') == 0
    assert char_to_value('9') == 9
    assert char_to_value('A') == 10
    assert char_to_value('Z') == 35

def test_check_digit_calculation():
    # Document number: N8492014, check digit 7
    chk = calculate_check_digit("N8492014")
    assert chk == 7

def test_valid_mrz_parsing():
    # Sample TD3 MRZ (2 lines, 44 chars each)
    line1 = "P<EGYMANSOOR<<AHMED<<<<<<<<<<<<<<<<<<<<<<<<<"
    line2 = "N8492014<8EGY9104225M2903091<<<<<<<<<<<<<<<2"
    
    res = parse_td3_mrz(line1, line2)
    assert res.is_valid is True
    assert res.surname == "MANSOOR"
    assert res.given_names == "AHMED"
    assert res.passport_number == "N8492014"
    assert res.issuing_country == "EGY"
    assert res.nationality == "EGY"
    assert res.gender == "M"
    assert res.date_of_birth == date(1991, 4, 22)
    assert res.expiry_date == date(2029, 3, 9)
    assert res.has_six_months_validity is True
    assert res.days_until_expiry > 180

def test_invalid_mrz_length():
    res = parse_td3_mrz("INVALID_LINE_1", "INVALID_LINE_2")
    assert res.is_valid is False
    assert len(res.validation_errors) > 0

def test_mrz_near_expiry():
    # Construct an MRZ that expires tomorrow
    today = date.today()
    exp_near = today + timedelta(days=30)
    exp_str = exp_near.strftime("%y%m%d")
    chk = calculate_check_digit(exp_str)
    
    line1 = "P<INDVERMA<<RAJESH<<<<<<<<<<<<<<<<<<<<<<<<<<"
    line2 = f"Z1234567<3IND8501014M{exp_str}{chk}<<<<<<<<<<<<<<<8"
    
    res = parse_td3_mrz(line1, line2)
    # Check that 6 months validity rule fails
    assert res.has_six_months_validity is False
    assert any("180 days" in err for err in res.validation_errors)
