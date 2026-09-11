import asyncio
import uuid
from datetime import datetime, timedelta, date
from sqlalchemy import select, text
from app.database import AsyncSessionLocal, engine, Base
from app.models.user import User
from app.models.candidate import CandidateProfile, CandidateExperience, CandidateEducation, CandidateSkill
from app.models.job import Company, Job, WalkinDrive
from app.models.application import JobApplication, ApplicationTimelineEvent
from app.models.vault import DocumentVault
from app.core.security import get_password_hash

async def seed_production_database():
    async with AsyncSessionLocal() as session:
        print("Checking existing database contents...")
        existing_jobs_res = await session.execute(select(Job).limit(10))
        existing_jobs = existing_jobs_res.scalars().all()
        if len(existing_jobs) >= 10:
            print(f"Database already contains {len(existing_jobs)}+ jobs. Ensuring demo pipeline and walkin drives exist...")
        else:
            print("Enriching database with comprehensive multi-country GCC production data...")

        # 1. Ensure Demo Candidate User exists
        user_stmt = select(User).where(User.email == "candidate@suhana-global.com")
        demo_user = (await session.execute(user_stmt)).scalar_one_or_none()

        if not demo_user:
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

        # Ensure Candidate Profile
        prof_stmt = select(CandidateProfile).where(CandidateProfile.user_id == demo_user.id)
        profile = (await session.execute(prof_stmt)).scalar_one_or_none()

        if not profile:
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

        # 2. Verified GCC Companies (All 6 Countries)
        companies_data = [
            # KSA
            {
                "name": "PetroGulf Energy Ltd.",
                "country_code": "KSA",
                "city": "Dammam",
                "logo_url": "https://images.unsplash.com/photo-1541888946425-d0fbb1861593?w=128",
                "commercial_reg_number": "CR-2050119842",
                "recruiter_whatsapp": "+966551234908"
            },
            {
                "name": "NEOM Infrastructure & Energy Consortium",
                "country_code": "KSA",
                "city": "NEOM Community 1",
                "logo_url": "https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=128",
                "commercial_reg_number": "CR-7001928374",
                "recruiter_whatsapp": "+966509988776"
            },
            # UAE
            {
                "name": "Al Habtoor FM Services",
                "country_code": "UAE",
                "city": "Dubai",
                "logo_url": "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=128",
                "commercial_reg_number": "DED-749201",
                "recruiter_whatsapp": "+971509876543"
            },
            {
                "name": "Petrofac Emirates EPC",
                "country_code": "UAE",
                "city": "Abu Dhabi",
                "logo_url": "https://images.unsplash.com/photo-1513836279014-a89f7a76ae86?w=128",
                "commercial_reg_number": "AD-884920",
                "recruiter_whatsapp": "+971523456789"
            },
            # Qatar
            {
                "name": "Qatar National Facilities Corp (QNFC)",
                "country_code": "QAT",
                "city": "Doha",
                "logo_url": "https://images.unsplash.com/photo-1497366216548-37526070297c?w=128",
                "commercial_reg_number": "CR-89420",
                "recruiter_whatsapp": "+97455887766"
            },
            # Kuwait
            {
                "name": "Kuwait Oil Engineering Services (KOES)",
                "country_code": "KWT",
                "city": "Ahmadi",
                "logo_url": "https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=128",
                "commercial_reg_number": "KWT-449102",
                "recruiter_whatsapp": "+96599112233"
            },
            # Oman
            {
                "name": "Bahwan Engineering & Maritime LLC",
                "country_code": "OMN",
                "city": "Muscat",
                "logo_url": "https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=128",
                "commercial_reg_number": "OMN-881290",
                "recruiter_whatsapp": "+96892345678"
            },
            # Bahrain
            {
                "name": "Bahrain Industrial & Marine Services (BIMS)",
                "country_code": "BHR",
                "city": "Manama",
                "logo_url": "https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=128",
                "commercial_reg_number": "BHR-112349",
                "recruiter_whatsapp": "+97333445566"
            }
        ]

        company_map = {}
        for cdata in companies_data:
            c_stmt = select(Company).where(Company.name == cdata["name"])
            existing_c = (await session.execute(c_stmt)).scalar_one_or_none()
            if not existing_c:
                existing_c = Company(
                    name=cdata["name"],
                    country_code=cdata["country_code"],
                    city=cdata["city"],
                    logo_url=cdata["logo_url"],
                    commercial_reg_number=cdata["commercial_reg_number"],
                    is_mofa_registered=True,
                    is_mhrsd_licensed=True,
                    is_verified_employer=True,
                    recruiter_whatsapp=cdata["recruiter_whatsapp"]
                )
                session.add(existing_c)
                await session.flush()
            company_map[cdata["name"]] = existing_c

        await session.flush()

        # 3. Comprehensive GCC Vacancies across all sectors
        vacancies = [
            # KSA - Oil & Gas
            {
                "company": "PetroGulf Energy Ltd.",
                "ref": "PG-HSE-908",
                "title": "Senior Offshore HSE Supervisor",
                "sector": "Oil & Gas",
                "country": "KSA",
                "city": "Dammam",
                "min_sal": 14000.0,
                "max_sal": 18000.0,
                "curr": "SAR",
                "visa": "Free Visa & Work Permit Provided",
                "rotation": "28/28 On/Off",
                "exp": 5.0,
                "skills": ["NEBOSH IGC", "OPITO BOSIET", "Saudi Aramco Approval", "PTW Mastery"],
                "benefits": ["100% Company Covered Visa", "Annual Return Flights", "Full Camp Lodging", "Medical Cover"],
                "desc": "Overseeing zero-incident safety operations across Jack-up drill rigs and offshore platforms.",
                "urgent": True
            },
            # KSA - Renewable Energy / Green Hydrogen
            {
                "company": "NEOM Infrastructure & Energy Consortium",
                "ref": "NEOM-HYD-041",
                "title": "Green Hydrogen Plant Operations Lead",
                "sector": "Green Tech",
                "country": "KSA",
                "city": "Oxagon (NEOM)",
                "min_sal": 22000.0,
                "max_sal": 28000.0,
                "curr": "SAR",
                "visa": "Premium Iqama & Relocation Package",
                "rotation": "4 Weeks On / 2 Weeks Off",
                "exp": 6.0,
                "skills": ["Electrolysis Systems", "Cryogenic Storage", "PLC/SCADA", "Process Safety"],
                "benefits": ["Subsidized NEOM Housing", "Family Status Visa", "Executive Medical Insurance", "Relocation Allowance"],
                "desc": "Lead operations at the world's largest green hydrogen production facility in Oxagon.",
                "urgent": True
            },
            # UAE - Facilities Management & MEP
            {
                "company": "Al Habtoor FM Services",
                "ref": "AH-MEP-412",
                "title": "Lead MEP Project Technician",
                "sector": "Facilities Management",
                "country": "UAE",
                "city": "Dubai",
                "min_sal": 6500.0,
                "max_sal": 8200.0,
                "curr": "AED",
                "visa": "2-Year Renewable Residence Visa",
                "rotation": "Annual 30-Day Paid Leave",
                "exp": 4.0,
                "skills": ["HVAC Chiller Maintenance", "BMS Operation", "Fire Suppression Systems"],
                "benefits": ["Free Single Accommodation", "Company Transport", "Comprehensive UAE Health Insurance"],
                "desc": "Leading MEP maintenance routines and preventive asset management across luxury hospitality assets.",
                "urgent": False
            },
            # UAE - Construction & Mega EPC
            {
                "company": "Petrofac Emirates EPC",
                "ref": "PE-CIV-501",
                "title": "Senior Pipeline Structural Engineer",
                "sector": "Construction & Infrastructure",
                "country": "UAE",
                "city": "Abu Dhabi",
                "min_sal": 18000.0,
                "max_sal": 24000.0,
                "curr": "AED",
                "visa": "ADNOC Approved Work Permit",
                "rotation": "Annual 30-Day Paid Leave",
                "exp": 7.0,
                "skills": ["AutoCAD Civil 3D", "STAAD.Pro", "Offshore Pipelay", "API 1104 Standards"],
                "benefits": ["Flight Allowance", "Schooling Assistance", "Comprehensive Health Care"],
                "desc": "Lead structural designs and installation methods for subsea gas transmission arteries.",
                "urgent": True
            },
            # Qatar - Infrastructure
            {
                "company": "Qatar National Facilities Corp (QNFC)",
                "ref": "QN-CIV-105",
                "title": "Civil Infrastructure QC Inspector",
                "sector": "Construction & Infrastructure",
                "country": "QAT",
                "city": "Doha",
                "min_sal": 9000.0,
                "max_sal": 11500.0,
                "curr": "QAR",
                "visa": "Government Project Visa Provided",
                "rotation": "Annual 30-Day Paid Leave",
                "exp": 5.0,
                "skills": ["Concrete Testing", "Asphalt Inspection", "ISO 9001 Auditing"],
                "benefits": ["Furnished Apartment Allowance", "Flight Tickets", "Private Health Insurance"],
                "desc": "Quality control inspections on expressways and utility tunnels for major Lusail infrastructure.",
                "urgent": True
            },
            # Kuwait - Petrochemical / Oil & Gas
            {
                "company": "Kuwait Oil Engineering Services (KOES)",
                "ref": "KO-INS-202",
                "title": "Instrumentation & Controls Specialist",
                "sector": "Oil & Gas",
                "country": "KWT",
                "city": "Ahmadi",
                "min_sal": 1100.0,
                "max_sal": 1450.0,
                "curr": "KWD",
                "visa": "Kuwait Ministry Article 18 Visa Provided",
                "rotation": "42/21 On/Off Rotation",
                "exp": 5.0,
                "skills": ["Emerson DeltaV DCS", "Transmitter Calibration", "SIL2 Safety Loops", "HART Protocol"],
                "benefits": ["Field Allowance", "Free Single Camp Accommodation", "Annual Ticket"],
                "desc": "Maintain complex refinery instrumentation and safety instrumented systems at Mina Al-Ahmadi.",
                "urgent": True
            },
            # Oman - Maritime & Port Logistics
            {
                "company": "Bahwan Engineering & Maritime LLC",
                "ref": "BE-MAR-304",
                "title": "Marine Port Crane Electrical Supervisor",
                "sector": "Marine & Maritime",
                "country": "OMN",
                "city": "Sohar",
                "min_sal": 1100.0,
                "max_sal": 1400.0,
                "curr": "OMR",
                "visa": "Oman Ministry of Labour Investor/Work Visa",
                "rotation": "Annual 30-Day Paid Vacation",
                "exp": 4.5,
                "skills": ["STS Container Cranes", "Siemens S7 PLC", "Medium Voltage Switchgear", "Variable Frequency Drives"],
                "benefits": ["Family Medical Cover", "Furnished Villa Housing", "Schooling Allowance"],
                "desc": "Oversee preventive and breakdown electrical maintenance for ship-to-shore gantry cranes at Sohar Port.",
                "urgent": False
            },
            # Bahrain - Industrial & Marine
            {
                "company": "Bahrain Industrial & Marine Services (BIMS)",
                "ref": "BM-WLD-118",
                "title": "6G Argon/TIG Certified Pipe Welder",
                "sector": "Industrial & Heavy Engineering",
                "country": "BHR",
                "city": "Hidd Industrial Area",
                "min_sal": 650.0,
                "max_sal": 850.0,
                "curr": "BHD",
                "visa": "Bahrain LMRA Flexi/Work Visa Provided",
                "rotation": "Annual Paid Leave with Ticket",
                "exp": 3.5,
                "skills": ["6G GTAW/SMAW", "Duplex Stainless Steel", "X-Ray Weld Quality", "ASME IX"],
                "benefits": ["Company Messing & Lodging", "Full Safety PPE", "Medical Coverage"],
                "desc": "Execute high-pressure pipe welds for shipyard conversions and offshore vessel retrofits.",
                "urgent": True
            }
        ]

        added_jobs = []
        for vac in vacancies:
            comp = company_map.get(vac["company"])
            if not comp:
                continue

            j_stmt = select(Job).where(Job.reference_code == vac["ref"])
            job = (await session.execute(j_stmt)).scalar_one_or_none()
            if not job:
                job = Job(
                    company_id=comp.id,
                    reference_code=vac["ref"],
                    title=vac["title"],
                    sector=vac["sector"],
                    country_code=vac["country"],
                    city=vac["city"],
                    salary_min=vac["min_sal"],
                    salary_max=vac["max_sal"],
                    salary_currency=vac["curr"],
                    visa_status=vac["visa"],
                    rotation_schedule=vac["rotation"],
                    required_experience_years=vac["exp"],
                    required_skills=vac["skills"],
                    relocation_benefits=vac["benefits"],
                    description=vac["desc"],
                    zero_recruitment_fee_guarantee=True,
                    is_urgent=vac["urgent"],
                    is_active=True
                )
                session.add(job)
                await session.flush()
            added_jobs.append(job)

        # 4. Mega Walk-in Recruitment Drives (Yanbu & Jubail)
        c_petro = company_map.get("PetroGulf Energy Ltd.")
        if c_petro:
            drive_stmt = select(WalkinDrive).where(WalkinDrive.city == "Yanbu Industrial City")
            drive = (await session.execute(drive_stmt)).scalar_one_or_none()
            if not drive:
                drive = WalkinDrive(
                    company_id=c_petro.id,
                    title="Mega Walk-in Drive — Petrochemical & Offshore Expansion",
                    country_code="KSA",
                    city="Yanbu Industrial City",
                    venue_name="Royal Commission Convention Center, Hall B",
                    venue_address="King Abdulaziz Rd, Yanbu Al-Sinaiyah, KSA",
                    start_date=datetime.utcnow() + timedelta(days=12),
                    end_date=datetime.utcnow() + timedelta(days=14),
                    time_slots=[
                        "12 Nov - Morning (08:30 AM)",
                        "12 Nov - Afternoon (01:30 PM)",
                        "13 Nov - Morning (08:30 AM)",
                        "13 Nov - Afternoon (01:30 PM)",
                        "14 Nov - Jubail Final Session (09:00 AM)"
                    ],
                    available_quotas=1200,
                    registered_count=420,
                    qr_code_prefix="KSA-WALKIN-2025-",
                    is_active=True
                )
                session.add(drive)
                await session.flush()

        # 5. Populate Active 6-Stage Relocation Pipeline for Demo Candidate
        if added_jobs and demo_user:
            app_stmt = select(JobApplication).where(JobApplication.user_id == demo_user.id)
            existing_apps = (await session.execute(app_stmt)).scalars().all()

            if not existing_apps:
                target_job = added_jobs[0]  # Senior Offshore HSE Supervisor
                app1 = JobApplication(
                    job_id=target_job.id,
                    user_id=demo_user.id,
                    status="visa_processing",
                    applied_at=datetime.utcnow() - timedelta(days=18)
                )
                session.add(app1)
                await session.flush()

                # 5 Timeline events simulating live progression through 5 stages
                events = [
                    ApplicationTimelineEvent(
                        application_id=app1.id,
                        stage="applied",
                        title="Application Submitted",
                        description=f"Direct application submitted for {target_job.title} at {target_job.company.name}.",
                        timestamp=datetime.utcnow() - timedelta(days=18)
                    ),
                    ApplicationTimelineEvent(
                        application_id=app1.id,
                        stage="screening",
                        title="HR Credential Verification",
                        description="NEBOSH and BOSIET certificates verified against MOFA databases.",
                        timestamp=datetime.utcnow() - timedelta(days=14)
                    ),
                    ApplicationTimelineEvent(
                        application_id=app1.id,
                        stage="interview",
                        title="Technical Panel Cleared",
                        description="Scored 94% on Saudi Aramco HSE Technical Safety Assessment.",
                        timestamp=datetime.utcnow() - timedelta(days=8)
                    ),
                    ApplicationTimelineEvent(
                        application_id=app1.id,
                        stage="offer_issued",
                        title="Official Offer Letter Signed",
                        description="Offer letter accepted: SAR 16,500/mo + 28/28 rotation package.",
                        timestamp=datetime.utcnow() - timedelta(days=4)
                    ),
                    ApplicationTimelineEvent(
                        application_id=app1.id,
                        stage="visa_processing",
                        title="Work Visa Quota Allocated",
                        description="Qiwa contract authorized. GAMCA medical clearance submitted to Saudi Embassy.",
                        timestamp=datetime.utcnow() - timedelta(hours=6)
                    ),
                ]
                session.add_all(events)

        await session.commit()
        print("Neon PostgreSQL database successfully enriched with comprehensive multi-country production data!")

if __name__ == "__main__":
    asyncio.run(seed_production_database())
