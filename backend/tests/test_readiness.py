from datetime import date, timedelta
from app.models.candidate import CandidateProfile, CandidateEducation
from app.models.vault import DocumentVault
from app.services.readiness_service import calculate_relocation_readiness

def test_readiness_score_calculation():
    profile = CandidateProfile(
        target_job_title="Lead Piping Engineer",
        nationality="Indian",
        current_resident_country="United Arab Emirates",
        total_experience_years=8.0,
        gcc_experience_years=4.0
    )
    profile.educations = [
        CandidateEducation(is_attested=True)
    ]

    # No documents yet
    res_empty = calculate_relocation_readiness(profile, [])
    assert res_empty.relocation_readiness_score == 55 # 20 (profile) + 10 (exp) + 15 (gcc) + 10 (attested)
    assert "cv_uploaded" in res_empty.breakdown
    assert res_empty.breakdown["cv_uploaded"] == 0

    # With primary CV and valid passport
    cv_doc = DocumentVault(document_type="cv_resume")
    passport_doc = DocumentVault(
        document_type="passport",
        has_six_months_validity=True
    )
    res_full = calculate_relocation_readiness(profile, [cv_doc, passport_doc])
    # 20 + 10 + 15 + 15 (cv) + 20 (passport) + 10 (validity) + 10 (attestation) = 100!
    assert res_full.relocation_readiness_score == 100
    assert len(res_full.recommendations) == 0
