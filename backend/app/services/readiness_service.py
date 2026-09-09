from typing import Tuple, List, Dict
from app.models.candidate import CandidateProfile
from app.models.vault import DocumentVault
from app.schemas.candidate import ReadinessScoreResponse

def calculate_relocation_readiness(
    profile: CandidateProfile,
    documents: List[DocumentVault]
) -> ReadinessScoreResponse:
    score = 0
    breakdown = {}
    recommendations = []

    # 1. Profile Core Details (20 pts)
    if profile.target_job_title and profile.nationality and profile.current_resident_country:
        score += 20
        breakdown["profile_info"] = 20
    else:
        breakdown["profile_info"] = 10
        score += 10
        recommendations.append("Complete your profile title, nationality, and current residence.")

    # 2. Work Experience (10 pts)
    if profile.total_experience_years > 0:
        score += 10
        breakdown["total_experience"] = 10
    else:
        breakdown["total_experience"] = 0
        recommendations.append("Add your work experience history.")

    # 3. GCC Regional Experience (15 pts)
    if profile.gcc_experience_years > 0:
        score += 15
        breakdown["gcc_experience"] = 15
    else:
        breakdown["gcc_experience"] = 0
        recommendations.append("Highlight any previous GCC or Middle East project experience.")

    # 4. Resume / CV Document (15 pts)
    has_cv = any(d.document_type == "cv_resume" for d in documents)
    if has_cv:
        score += 15
        breakdown["cv_uploaded"] = 15
    else:
        breakdown["cv_uploaded"] = 0
        recommendations.append("Upload your latest CV/Resume to unlock 1-Tap Apply (+15%).")

    # 5. Passport & MRZ Status (30 pts: 20 pts for document + 10 pts for 6-month validity)
    passport_docs = [d for d in documents if d.document_type == "passport"]
    if passport_docs:
        score += 20
        breakdown["passport_uploaded"] = 20
        latest_passport = passport_docs[0]
        if latest_passport.has_six_months_validity:
            score += 10
            breakdown["passport_validity"] = 10
        else:
            breakdown["passport_validity"] = 0
            recommendations.append("Your passport has less than 6 months validity. Renew it for GCC visa clearance.")
    else:
        breakdown["passport_uploaded"] = 0
        breakdown["passport_validity"] = 0
        recommendations.append("Scan or upload your passport to complete your relocation vault (+30%).")

    # 6. Education Attestation / Certifications (10 pts)
    has_attested_edu = any(edu.is_attested for edu in (profile.educations or []))
    if has_attested_edu:
        score += 10
        breakdown["attestation"] = 10
    else:
        breakdown["attestation"] = 0
        recommendations.append("Verify your educational degree attestation (MOFA/Embassy) (+10%).")

    score = min(100, max(0, score))

    return ReadinessScoreResponse(
        relocation_readiness_score=score,
        breakdown=breakdown,
        recommendations=recommendations
    )
