import asyncio
from datetime import datetime, timedelta, date
from uuid import uuid4
from sqlalchemy import select, text
from app.database import AsyncSessionLocal, engine, Base
from app.models.user import User
from app.models.candidate import CandidateProfile, CandidateExperience, CandidateEducation, CandidateSkill
from app.models.job import Company, Job, WalkinDrive
from app.models.vault import DocumentVault
from app.core.security import get_password_hash

async def seed_database():
    async with AsyncSessionLocal() as session:
        # Check if already seeded
        res = await session.execute(select(Job).limit(1))
        if res.scalar_one_or_none():
            print("Database already contains jobs. Skipping seed.")
            return

        print("Seeding database with verified GCC companies, jobs, and candidate profile...")

        # 1. Create Demo Candidate User
        demo_user = User(
            email="candidate@suhana-global.com",
            phone_country_code="+966",
            phone_number="550123456",
            password_hash=get_password_hash("Secret123!"),
            full_name="Ahmed Mansoor Al-Sayed",
            role="candidate",
            preferred_language="en",
            is_phone_verified=True,
            is_active=True
        )
        session.add(demo_user)
        await session.flush()

        # Candidate Profile
        profile = CandidateProfile(
            user_id=demo_user.id,
            target_job_title="Senior Offshore HSE Supervisor",
            current_resident_country="Egypt",
            current_city="Alexandria",
            nationality="Egyptian",
            total_experience_years=7.5,
            gcc_experience_years=4.0,
            relocation_readiness_score=85,
            is_actively_looking=True,
            is_gcc_verified=True,
            notice_period_days=30,
            relocation_status="Ready for Relocation",
            expected_salary_min=14000.00,
            expected_salary_currency="SAR",
            bio="Certified HSE professional with extensive offshore platform and turnaround experience across the Arabian Gulf.",
            linkedin_url="https://linkedin.com/in/ahmed-mansoor-hse"
        )
        session.add(profile)
        await session.flush()

        # Add Experience
        exp = CandidateExperience(
            profile_id=profile.id,
            company="Consolidated Contractors Co. (CCC)",
            title="Offshore HSE Specialist",
            country="Saudi Arabia",
            city="Jubail",
            start_date="2020",
            end_date="Present",
            is_current=True,
            description="Leading safety walkthroughs, PTW audits, and incident investigations on offshore gas platforms."
        )
        session.add(exp)

        # Add Education
        edu = CandidateEducation(
            profile_id=profile.id,
            degree="B.Sc. in Petroleum & Mining Engineering",
            field_of_study="Safety Engineering",
            institution="Suez University",
            country="Egypt",
            graduation_year=2017,
            is_attested=True
        )
        session.add(edu)

        # Add Skills
        for s, y in [("NEBOSH IGC", 5.0), ("BOSIET Offshore", 4.0), ("Saudi Aramco SAP ID", 3.0), ("PTW Permit-To-Work", 6.0)]:
            skill = CandidateSkill(profile_id=profile.id, skill_name=s, years_of_experience=y, is_verified=True)
            session.add(skill)

        # Add Document Vault (Passport & CV)
        passport_doc = DocumentVault(
            user_id=demo_user.id,
            document_type="passport",
            file_name="Ahmed_Mansoor_Passport.pdf",
            file_url="/static/uploads/sample_passport.pdf",
            mime_type="application/pdf",
            passport_number="N8492014",
            issuing_country="EGY",
            country_code_icao="EGY",
            passport_nationality="EGY",
            surname="MANSOOR",
            given_names="AHMED",
            date_of_birth=date(1991, 4, 22),
            gender="M",
            issue_date=date(2022, 3, 10),
            expiry_date=date.today() + timedelta(days=450), # > 6 months
            mrz_raw_line1="P<EGYMANSOOR<<AHMED<<<<<<<<<<<<<<<<<<<<<<<<<",
            mrz_raw_line2="N8492014<8EGY9104225M2903091<<<<<<<<<<<<<<<2",
            is_mrz_checksum_valid=True,
            has_six_months_validity=True,
            is_verified=True,
            verification_status="verified"
        )
        session.add(passport_doc)

        # 2. Verified GCC Companies
        c1 = Company(
            name="PetroGulf Energy Ltd.",
            country_code="KSA",
            city="Dammam",
            logo_url="https://images.unsplash.com/photo-1541888946425-d0fbb1861593?w=128",
            commercial_reg_number="CR-2050119842",
            is_mofa_registered=True,
            is_mhrsd_licensed=True,
            is_verified_employer=True,
            recruiter_whatsapp="+966551234908"
        )
        c2 = Company(
            name="Al Habtoor FM Services",
            country_code="UAE",
            city="Dubai",
            logo_url="https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=128",
            commercial_reg_number="DED-749201",
            is_mofa_registered=True,
            is_mhrsd_licensed=True,
            is_verified_employer=True,
            recruiter_whatsapp="+971509876543"
        )
        c3 = Company(
            name="Qatar National Facilities Corp (QNFC)",
            country_code="QAT",
            city="Doha",
            logo_url="https://images.unsplash.com/photo-1497366216548-37526070297c?w=128",
            commercial_reg_number="CR-89420",
            is_mofa_registered=True,
            is_mhrsd_licensed=True,
            is_verified_employer=True,
            recruiter_whatsapp="+97455887766"
        )
        session.add_all([c1, c2, c3])
        await session.flush()

        # 3. Verified GCC Jobs
        j1 = Job(
            company_id=c1.id,
            reference_code="PG-HSE-908",
            title="Senior Offshore HSE Supervisor",
            sector="Oil & Gas",
            country_code="KSA",
            city="Dammam",
            salary_min=14000.00,
            salary_max=18000.00,
            salary_currency="SAR",
            visa_status="Free Visa & Work Permit Provided",
            rotation_schedule="28/28 On/Off",
            required_experience_years=5.0,
            required_skills=["NEBOSH IGC", "OPITO BOSIET", "Saudi Aramco Approval", "PTW Mastery"],
            relocation_benefits=["100% Company Covered Visa", "Annual Return Flights", "Full Camp Lodging", "Medical Cover"],
            description="Overseeing zero-incident safety operations across Jack-up drill rigs and offshore platforms.",
            zero_recruitment_fee_guarantee=True,
            is_urgent=True
        )
        j2 = Job(
            company_id=c2.id,
            reference_code="AH-MEP-412",
            title="Lead MEP Project Technician",
            sector="Facilities Management",
            country_code="UAE",
            city="Dubai",
            salary_min=6500.00,
            salary_max=8200.00,
            salary_currency="AED",
            visa_status="2-Year Renewable Residence Visa",
            rotation_schedule="Annual 30-Day Paid Leave",
            required_experience_years=4.0,
            required_skills=["HVAC Chiller Maintenance", "BMS Operation", "Fire Suppression Systems"],
            relocation_benefits=["Free Single Accommodation", "Company Transport", "Comprehensive UAE Health Insurance"],
            description="Leading MEP maintenance routines and preventive asset management across luxury hospitality assets.",
            zero_recruitment_fee_guarantee=True,
            is_urgent=False
        )
        j3 = Job(
            company_id=c3.id,
            reference_code="QN-CIV-105",
            title="Civil Infrastructure QC Inspector",
            sector="Construction & Infrastructure",
            country_code="QAT",
            city="Doha",
            salary_min=9000.00,
            salary_max=11500.00,
            salary_currency="QAR",
            visa_status="Government Project Visa Provided",
            rotation_schedule="Annual 30-Day Paid Leave",
            required_experience_years=5.0,
            required_skills=["Concrete Testing", "Asphalt Inspection", "ISO 9001 Auditing"],
            relocation_benefits=["Furnished Apartment Allowance", "Flight Tickets", "Private Health Insurance"],
            description="Quality control inspections on expressways and utility tunnels for major Lusail infrastructure.",
            zero_recruitment_fee_guarantee=True,
            is_urgent=True
        )
        session.add_all([j1, j2, j3])

        # 4. Mega Walk-in Recruitment Drive
        drive = WalkinDrive(
            company_id=c1.id,
            title="Mega Walk-in Drive — Petrochemical & Offshore Expansion",
            country_code="KSA",
            city="Yanbu Industrial City",
            venue_name="Royal Commission Convention Center, Hall B",
            venue_address="King Abdulaziz Rd, Yanbu Al-Sinaiyah, KSA",
            start_date=datetime.utcnow() + timedelta(days=12),
            end_date=datetime.utcnow() + timedelta(days=14),
            time_slots=["09:00 AM - 11:00 AM", "11:30 AM - 01:30 PM", "03:00 PM - 05:00 PM", "06:00 PM - 08:00 PM"],
            available_quotas=1200,
            registered_count=348,
            qr_code_prefix="YANBU26-",
            is_active=True
        )
        session.add(drive)

        await session.commit()
        print("Database successfully seeded with demo data!")

if __name__ == "__main__":
    asyncio.run(seed_database())
