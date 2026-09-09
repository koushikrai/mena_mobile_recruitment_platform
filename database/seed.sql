-- ============================================================================
-- GLOBAL JOBS BY SUHANA — MENA MOBILE RECRUITMENT PLATFORM
-- PRODUCTION SEED DATA (GCC Employers, Jobs, Pipeline, and Vault)
-- ============================================================================

-- 1. Create Demo Users
INSERT INTO users (id, email, phone_country_code, phone_number, password_hash, role, full_name, avatar_url, preferred_language)
VALUES 
('11111111-1111-1111-1111-111111111111', 'koushik.candidate@example.com', '+971', '501234567', crypt('SecurePass123!', gen_salt('bf')), 'candidate', 'Koushik Rai', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200', 'en'),
('22222222-2222-2222-2222-222222222222', 'recruiter@emaar.ae', '+971', '509876543', crypt('EmaarPass2026!', gen_salt('bf')), 'employer', 'Ahmed Al-Mansoor', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200', 'en'),
('33333333-3333-3333-3333-333333333333', 'talent@aramco.com.sa', '+966', '551122334', crypt('AramcoCareers!', gen_salt('bf')), 'employer', 'Fahad Al-Otaibi', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200', 'ar')
ON CONFLICT (id) DO NOTHING;

-- 2. Create Candidate Profile
INSERT INTO candidate_profiles (
    id, user_id, target_job_title, current_resident_country, current_city, nationality, 
    total_experience_years, gcc_experience_years, relocation_readiness_score, is_actively_looking, 
    is_gcc_verified, notice_period_days, relocation_status, expected_salary_min, expected_salary_currency, bio
) VALUES (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    '11111111-1111-1111-1111-111111111111',
    'Senior Civil Site Engineer',
    'India',
    'Mumbai',
    'Indian',
    7,
    3,
    85,
    TRUE,
    TRUE,
    30,
    'Ready for GCC Relocation',
    18000.00,
    'AED',
    'Experienced Civil Engineer with 7+ years of experience across high-rise infrastructure in Dubai and Bangalore. Certified with Saudi Council of Engineers (SCE).'
) ON CONFLICT (id) DO NOTHING;

-- Preferred Countries for Relocation
INSERT INTO candidate_preferred_countries (candidate_profile_id, country_code)
VALUES 
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'uae'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'sau'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'qat')
ON CONFLICT DO NOTHING;

-- 3. Create Verified GCC Companies
INSERT INTO companies (
    id, user_id, name, name_ar, logo_url, industry, country_code, city, 
    headquarters_address, website, commercial_reg_number, is_mofa_registered, is_verified_employer, company_size, about_description
) VALUES 
(
    'c1111111-1111-1111-1111-111111111111',
    '22222222-2222-2222-2222-222222222222',
    'Emaar Properties PJSC',
    'إعمار العقارية',
    'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=128',
    'Real Estate & Construction',
    'uae',
    'Dubai',
    'Downtown Dubai, Boulevard Plaza Tower 1',
    'https://www.emaar.com',
    'CN-1002341',
    TRUE,
    TRUE,
    '10,000+ employees',
    'Global master developer of iconic assets including Burj Khalifa and Dubai Mall.'
),
(
    'c2222222-2222-2222-2222-222222222222',
    '33333333-3333-3333-3333-333333333333',
    'NEOM Project Development',
    'مشروع نيوم',
    'https://images.unsplash.com/photo-1541888946425-d0fbb18086f6?w=128',
    'Renewable Infrastructure & Smart Cities',
    'sau',
    'Tabuk / Riyadh',
    'NEOM Community 1, Tabuk Province',
    'https://www.neom.com',
    'CR-700192834',
    TRUE,
    TRUE,
    '5000+ employees',
    'The land of the future, pioneering sustainable urban living and cutting-edge engineering.'
),
(
    'c3333333-3333-3333-3333-333333333333',
    NULL,
    'Qatar Airways Group',
    'الخطوط الجوية القطرية',
    'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=128',
    'Aviation & Logistics',
    'qat',
    'Doha',
    'Qatar Airways Tower 1, Airport Road, Doha',
    'https://www.qatarairways.com',
    'QCR-45812',
    TRUE,
    TRUE,
    '45,000+ employees',
    'Award-winning national carrier of the State of Qatar.'
)
ON CONFLICT (id) DO NOTHING;

-- 4. Create Verified Jobs
INSERT INTO jobs (
    id, company_id, title, department, country_code, city, employment_type,
    salary_min, salary_max, currency, is_tax_free, visa_status, accommodation,
    relocation_benefits, mofa_attestation_required, gamca_medical_required,
    iqama_transferable, police_clearance_required, application_deadline,
    required_languages, job_description, responsibilities, qualifications, required_skills
) VALUES 
(
    'j1111111-1111-1111-1111-111111111111',
    'c1111111-1111-1111-1111-111111111111',
    'Senior Civil Site Engineer (High-Rise)',
    'Construction & Engineering',
    'uae',
    'Dubai',
    'Full-time',
    18000.00,
    25000.00,
    'AED',
    TRUE,
    'Fully Sponsored',
    'Housing Allowance',
    ARRAY['Relocation Flight', 'Family Visa Sponsorship', 'Comprehensive Health Insurance (Network A)', 'Annual Ticket Home', 'End of Service Gratuity'],
    TRUE,
    TRUE,
    FALSE,
    TRUE,
    NOW() + INTERVAL '30 days',
    'English / Arabic Preferred',
    'Lead on-site civil structural execution for a flagship 65-story residential tower in Dubai Creek Harbour.',
    ARRAY['Supervise sub-contractors on structural pour and MEP coordination', 'Enforce UAE Building Code and DM safety protocols', 'Review RFIs and material submittals with consultant'],
    ARRAY['B.Sc. in Civil Engineering (MOFA Attested)', 'Minimum 6 years high-rise construction experience', 'Valid UAE Driving License is an advantage'],
    ARRAY['AutoCAD', 'Revit', 'Primavera P6', 'Site Supervision', 'QA/QC Inspection']
),
(
    'j2222222-2222-2222-2222-222222222222',
    'c2222222-2222-2222-2222-222222222222',
    'Lead Renewable Energy Specialist',
    'Green Energy & Utilities',
    'sau',
    'NEOM / Tabuk',
    'Full-time',
    28000.00,
    38000.00,
    'SAR',
    TRUE,
    'Fully Sponsored',
    'Provided',
    ARRAY['Executive Compound Housing', 'Full Family Relocation', 'International Schooling Allowance', '4x Annual Return Flights', 'Tax Free Income'],
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    NOW() + INTERVAL '45 days',
    'English',
    'Drive utility-scale solar PV and green hydrogen infrastructure integration for the Line project.',
    ARRAY['Oversee 500MW+ solar grid synchronizations', 'Liaise with Saudi Electricity Company and international OEMs'],
    ARRAY['Master in Renewable Systems or Electrical Engineering', 'Saudi Council of Engineers (SCE) accreditation eligible', '8+ years utility scale solar'],
    ARRAY['Grid Interconnection', 'Solar PV', 'Energy Storage', 'SCE Member', 'SCADA']
)
ON CONFLICT (id) DO NOTHING;

-- 5. Create Sample Application in 6-Stage Relocation Pipeline
INSERT INTO job_applications (
    id, user_id, job_id, current_stage, status_label, severity,
    missing_documents, next_deadline, recruiter_contact, applied_date
) VALUES (
    'app11111-1111-1111-1111-111111111111',
    '11111111-1111-1111-1111-111111111111',
    'j1111111-1111-1111-1111-111111111111',
    'visaProcessing',
    'Entry Permit Issued — Stamping Pending',
    'verified',
    ARRAY['GAMCA Medical Fitness Certificate'],
    NOW() + INTERVAL '5 days',
    'Ahmed Al-Mansoor (Emaar Talent Acquisition)',
    NOW() - INTERVAL '14 days'
) ON CONFLICT (id) DO NOTHING;

-- Timeline Events for the Application
INSERT INTO application_timeline_events (application_id, stage, title, description, event_status, actor_type, event_timestamp)
VALUES 
('app11111-1111-1111-1111-111111111111', 'applied', 'Application Submitted', 'Profile and CV submitted to Emaar recruitment portal.', 'completed', 'candidate', NOW() - INTERVAL '14 days'),
('app11111-1111-1111-1111-111111111111', 'screening', 'Technical Screening Passed', 'CV matched 92% of required qualifications.', 'completed', 'employer', NOW() - INTERVAL '11 days'),
('app11111-1111-1111-1111-111111111111', 'interview', 'Technical & HR Interviews Completed', 'Candidate recommended for offer.', 'completed', 'employer', NOW() - INTERVAL '7 days'),
('app11111-1111-1111-1111-111111111111', 'offerIssued', 'Offer Letter Signed (22,000 AED/mo)', 'Digital contract signed via DocuSign.', 'completed', 'candidate', NOW() - INTERVAL '4 days'),
('app11111-1111-1111-1111-111111111111', 'visaProcessing', 'MOHRE Work Permit Approved & UAE Entry Visa Issued', 'Entry permit generated. GAMCA medical report upload required.', 'in_progress', 'system', NOW() - INTERVAL '1 day');

-- Visa Processing Record
INSERT INTO visa_processing_records (
    application_id, mofa_reference_number, entry_permit_number, visa_type,
    gamca_medical_center, gamca_fit_status, entry_permit_issue_date, entry_permit_expiry_date, status
) VALUES (
    'app11111-1111-1111-1111-111111111111',
    'MOFA-UAE-2026-88912',
    'EV-DXB-99823412',
    'Employment Residence Visa',
    'GAMCA Authorized Diagnostic Centre, Mumbai',
    TRUE,
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '60 days',
    'verified'
) ON CONFLICT DO NOTHING;

-- 6. Create Encrypted Document Vault & MRZ Records
INSERT INTO vault_documents (
    id, user_id, category, title, document_number, issuing_country,
    issue_date, expiry_date, is_valid_for_gcc_visa, is_verified, verification_status,
    file_url, reminder_6_months, reminder_3_months
) VALUES 
(
    'doc11111-1111-1111-1111-111111111111',
    '11111111-1111-1111-1111-111111111111',
    'passport',
    'International Passport',
    'N8829104',
    'India',
    '2021-06-15',
    '2031-06-14',
    TRUE,
    TRUE,
    'verified',
    'https://storage.googleapis.com/mena-vault-secure/users/111/passport_n8829104.enc',
    TRUE,
    TRUE
),
(
    'doc22222-2222-2222-2222-222222222222',
    '11111111-1111-1111-1111-111111111111',
    'educationAttestation',
    'B.Tech Civil Engineering Degree',
    'DEG-2018-7712',
    'India',
    '2018-07-20',
    NULL,
    TRUE,
    TRUE,
    'verified',
    'https://storage.googleapis.com/mena-vault-secure/users/111/degree_mofa.enc',
    FALSE,
    FALSE
),
(
    'doc33333-3333-3333-3333-333333333333',
    '11111111-1111-1111-1111-111111111111',
    'tradeLicense',
    'Saudi Council of Engineers (SCE) Membership',
    'SCE-MEM-99214',
    'Saudi Arabia',
    '2024-01-10',
    '2027-01-09',
    TRUE,
    TRUE,
    'verified',
    'https://storage.googleapis.com/mena-vault-secure/users/111/sce_cert.enc',
    TRUE,
    TRUE
)
ON CONFLICT (id) DO NOTHING;

-- Passport MRZ Line Extraction
INSERT INTO passport_mrz_data (
    vault_document_id, passport_type, country_code_icao, passport_number,
    surname, given_names, nationality_icao, date_of_birth, gender, expiry_date,
    mrz_raw_line1, mrz_raw_line2, is_checksum_valid, has_six_months_validity, face_id_match_score
) VALUES (
    'doc11111-1111-1111-1111-111111111111',
    'P',
    'IND',
    'N8829104',
    'RAI',
    'KOUSHIK',
    'IND',
    '1996-08-14',
    'M',
    '2031-06-14',
    'P<INDRAI<<KOUSHIK<<<<<<<<<<<<<<<<<<<<<<<<<<<',
    'N8829104<2IND9608144M3106148<<<<<<<<<<<<<<<4',
    TRUE,
    TRUE,
    98.5
) ON CONFLICT DO NOTHING;

-- 7. Seed PetroGulf Energy & Verified Offshore Oil & Gas Job
INSERT INTO companies (
    id, user_id, name, name_ar, logo_url, industry, country_code, city,
    headquarters_address, website, commercial_reg_number, is_mofa_registered,
    is_mhrsd_licensed, is_verified_employer, recruiter_whatsapp, company_size, about_description
) VALUES (
    'c4444444-4444-4444-4444-444444444444',
    NULL,
    'PetroGulf Energy Consortium',
    'اتحاد بتروجلف للطاقة',
    'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=128',
    'Offshore Oil & Gas Operations',
    'sau',
    'Al Khobar / Eastern Province',
    'King Abdulaziz Road, Al Khobar, Saudi Arabia',
    'https://www.petrogulfenergy.com',
    'CR-205199201',
    TRUE,
    TRUE,
    TRUE,
    '+966555123456',
    '2,500+ employees',
    'Leading EPC and offshore drilling contractor certified by Saudi Aramco and ADNOC.'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO jobs (
    id, company_id, reference_code, sector, title, department, country_code, city,
    employment_type, rotation_schedule, salary_min, salary_max, currency,
    is_tax_free, visa_status, accommodation, visa_allocation_covered,
    food_allowance_provided, annual_flights_provided, is_direct_employer,
    is_fast_track_mobilization, pre_deployment_fee_amount, relocation_benefits,
    mofa_attestation_required, gamca_medical_required, iqama_transferable,
    police_clearance_required, application_deadline, required_languages,
    job_description, responsibilities, qualifications, required_skills, cryptographic_stamp
) VALUES (
    'j4444444-4444-4444-4444-444444444444',
    'c4444444-4444-4444-4444-444444444444',
    'PG-HSE-908',
    'oilGas',
    'Senior Offshore HSE Supervisor',
    'Health, Safety & Environment',
    'sau',
    'Eastern Province / Offshore',
    'Rotational 28/28',
    '28/28 On/Off Rotational',
    28000.00,
    35000.00,
    'SAR',
    TRUE,
    'Direct Saudi Work Visa',
    'Offshore Accommodation & Full Messing',
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    0.00,
    ARRAY['Offshore Rig Living Quarters', 'Full Messing Provided', '28/28 Business Return Flights', 'Bupa Gold Medical Insurance', 'Direct Aramco Green Pass Sponsorship'],
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    NOW() + INTERVAL '20 days',
    'English (Required), Arabic (Advantage)',
    'Lead health, safety, and environmental stewardship across jack-up drilling rigs and offshore platforms in the Arabian Gulf. Ensure 100% compliance with Saudi Aramco Safety Handbook and GI 0002.100 work permit requirements.',
    ARRAY['Enforce Saudi Aramco Safety Handbook across offshore operations', 'Administer Work Permit System (Cold, Hot, Confined Space)', 'Conduct daily rig safety toolbox talks and emergency response drills', 'Coordinate incident investigation and HAZOP assessments'],
    ARRAY['Valid Saudi Aramco SAP/Vendor ID or Approval Card', 'NEBOSH International General Certificate (IGC) with Distinction/Credit', 'Valid OPITO-approved BOSIET/FOET with CA-EBS', 'Valid Saudi or GCC Heavy/Light Driving License'],
    ARRAY['Offshore Safety', 'Aramco GI Protocols', 'NEBOSH IGC', 'BOSIET', 'Incident Investigation', 'Risk Assessment'],
    'SHA256-MHRSD-KSA-VERIFIED-STAMP-2025-PG-HSE-908'
) ON CONFLICT (id) DO NOTHING;

-- 8. Seed Walk-in Recruitment Drives & Venues
INSERT INTO walkin_drives (
    id, company_id, job_id, drive_title, start_date, end_date,
    venues, total_quota_vacancies, required_documents, available_time_slots, is_active
) VALUES (
    'wd111111-1111-1111-1111-111111111111',
    'c4444444-4444-4444-4444-444444444444',
    'j4444444-4444-4444-4444-444444444444',
    'Mega Walk-In Recruitment Drive 2025 — Yanbu & Jubail Industrial Cities',
    CURRENT_DATE + INTERVAL '5 days',
    CURRENT_DATE + INTERVAL '7 days',
    ARRAY['Yanbu Industrial City — Royal Commission Convention Centre, Hall B', 'Jubail Industrial City — Al-Huwaylat Exhibition Complex, Gate 3'],
    1200,
    ARRAY['Physical Passport (min 6 months validity)', 'NEBOSH / Trade Certificates (Originals)', 'Saudi Aramco Approval Card / SAP ID', '4 Passport-size Photos with White Background'],
    ARRAY['09:00 AM - 11:00 AM (Priority Pass)', '11:30 AM - 01:30 PM', '02:30 PM - 05:00 PM'],
    TRUE
) ON CONFLICT (id) DO NOTHING;

-- 9. Seed Ahmed Mansoor (Profile from Flutter App Screens)
INSERT INTO users (id, email, phone_country_code, phone_number, password_hash, role, full_name, avatar_url, preferred_language)
VALUES (
    '44444444-4444-4444-4444-444444444444',
    'ahmed.mansoor@example.com',
    '+20',
    '1012345678',
    crypt('AramcoHse2025!', gen_salt('bf')),
    'candidate',
    'Ahmed Mansoor',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    'en'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO candidate_profiles (
    id, user_id, target_job_title, current_resident_country, current_city, nationality,
    total_experience_years, gcc_experience_years, relocation_readiness_score, is_actively_looking,
    is_gcc_verified, notice_period_days, relocation_status, expected_salary_min, expected_salary_currency,
    bio, linkedin_url
) VALUES (
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    '44444444-4444-4444-4444-444444444444',
    'Offshore HSE Supervisor',
    'Saudi Arabia',
    'Al Khobar',
    'Egyptian',
    8,
    5,
    96,
    TRUE,
    TRUE,
    15,
    'Transferable Iqama Available',
    30000.00,
    'SAR',
    'Senior HSE Professional with 8 years of offshore drilling safety supervision in the Red Sea and Arabian Gulf. Fully qualified with Saudi Aramco Approval Card (SAP-772918), NEBOSH IGC, and OPITO BOSIET.',
    'https://linkedin.com/in/ahmed-mansoor-hse'
) ON CONFLICT (id) DO NOTHING;

-- Ahmed Mansoor Credentials & Vault Items
INSERT INTO vault_documents (
    id, user_id, category, title, document_number, issuing_country,
    issue_date, expiry_date, is_valid_for_gcc_visa, is_verified, verification_status,
    file_url, reminder_6_months, reminder_3_months
) VALUES 
(
    'doc44444-4444-4444-4444-444444444444',
    '44444444-4444-4444-4444-444444444444',
    'passport',
    'Passport of Egypt',
    'N8492014',
    'Egypt',
    '2022-03-10',
    '2029-03-09',
    TRUE,
    TRUE,
    'verified',
    'https://storage.googleapis.com/mena-vault-secure/users/444/passport_n8492014.enc',
    TRUE,
    TRUE
),
(
    'doc55555-5555-5555-5555-555555555555',
    '44444444-4444-4444-4444-444444444444',
    'aramcoCard',
    'Saudi Aramco Approval Card',
    'SAP-772918',
    'Saudi Arabia',
    '2023-05-12',
    '2027-05-11',
    TRUE,
    TRUE,
    'verified',
    'https://storage.googleapis.com/mena-vault-secure/users/444/aramco_card_772918.enc',
    TRUE,
    TRUE
),
(
    'doc66666-6666-6666-6666-666666666666',
    '44444444-4444-4444-4444-444444444444',
    'tradeLicense',
    'NEBOSH International General Certificate in OHS',
    'NEB-0049281',
    'United Kingdom',
    '2020-11-18',
    NULL,
    TRUE,
    TRUE,
    'verified',
    'https://storage.googleapis.com/mena-vault-secure/users/444/nebosh_igc.enc',
    FALSE,
    FALSE
)
ON CONFLICT (id) DO NOTHING;

-- Ahmed Mansoor MRZ Extraction
INSERT INTO passport_mrz_data (
    vault_document_id, passport_type, country_code_icao, passport_number,
    surname, given_names, nationality_icao, date_of_birth, gender, expiry_date,
    mrz_raw_line1, mrz_raw_line2, is_checksum_valid, has_six_months_validity, face_id_match_score
) VALUES (
    'doc44444-4444-4444-4444-444444444444',
    'P',
    'EGY',
    'N8492014',
    'MANSOOR',
    'AHMED',
    'EGY',
    '1991-04-22',
    'M',
    '2029-03-09',
    'P<EGYMANSOOR<<AHMED<<<<<<<<<<<<<<<<<<<<<<<<<',
    'N8492014<8EGY9104225M2903091<<<<<<<<<<<<<<<2',
    TRUE,
    TRUE,
    99.2
) ON CONFLICT DO NOTHING;

-- Ahmed Mansoor Certifications
INSERT INTO professional_certifications (
    id, user_id, vault_document_id, body_name, certificate_name, license_number,
    issue_date, expiry_date, registry_verification_stamp, is_verified, verification_status
) VALUES 
(
    'cert1111-1111-1111-1111-111111111111',
    '44444444-4444-4444-4444-444444444444',
    'doc55555-5555-5555-5555-555555555555',
    'Saudi Aramco',
    'Work Permit Receiver & Safety Officer Approval',
    'SAP-772918',
    '2023-05-12',
    '2027-05-11',
    'ARAMCO-ID-VERIFIED-SAP-772918',
    TRUE,
    'verified'
),
(
    'cert2222-2222-2222-2222-222222222222',
    '44444444-4444-4444-4444-444444444444',
    'doc66666-6666-6666-6666-666666666666',
    'NEBOSH',
    'International General Certificate in Occupational Health and Safety',
    'NEB-0049281',
    '2020-11-18',
    NULL,
    'UK-NEBOSH-REGISTER-VERIFIED',
    TRUE,
    'verified'
) ON CONFLICT (id) DO NOTHING;

-- Ahmed Mansoor Saudi Driving License
INSERT INTO gcc_driving_licenses (
    id, user_id, vault_document_id, country_code, license_number,
    classification, issue_date, expiry_date, is_valid
) VALUES (
    'lic11111-1111-1111-1111-111111111111',
    '44444444-4444-4444-4444-444444444444',
    NULL,
    'sau',
    'KSA-DL-4482910',
    'Light Vehicle (Manual/Auto)',
    '2021-08-10',
    '2031-08-09',
    TRUE
) ON CONFLICT (id) DO NOTHING;

-- Walk-in Registration Pass for Ahmed Mansoor
INSERT INTO walkin_registrations (
    id, drive_id, user_id, selected_time_slot, selected_venue, qr_pass_code, status
) VALUES (
    'reg11111-1111-1111-1111-111111111111',
    'wd111111-1111-1111-1111-111111111111',
    '44444444-4444-4444-4444-444444444444',
    '09:00 AM - 11:00 AM (Priority Pass)',
    'Yanbu Industrial City — Royal Commission Convention Centre, Hall B',
    'MENA-PASS-YNB-2025-9912',
    'registered'
) ON CONFLICT (id) DO NOTHING;

-- Job Application to PetroGulf PG-HSE-908 with Auto-Attached Vault
INSERT INTO job_applications (
    id, user_id, job_id, current_stage, status_label, severity,
    missing_documents, next_deadline, recruiter_contact, cover_note,
    auto_attached_vault_cv, auto_attached_passport_num, attached_credential_ids, applied_date
) VALUES (
    'app22222-2222-2222-2222-222222222222',
    '44444444-4444-4444-4444-444444444444',
    'j4444444-4444-4444-4444-444444444444',
    'screening',
    'Application Under Review — Saudi Aramco Vendor Clearance',
    'verified',
    '{}',
    NOW() + INTERVAL '3 days',
    'Tariq Al-Zahrani (PetroGulf HR Lead) via WhatsApp (+966555123456)',
    'Enclosed my verified profile with Saudi Aramco Approval Card (SAP-772918), valid NEBOSH certificate, and BOSIET for immediate offshore rotational mobilization.',
    'Ahmed_Mansoor_HSE_Offshore_CV.pdf',
    'N8492014',
    ARRAY['cert1111-1111-1111-1111-111111111111'::UUID, 'cert2222-2222-2222-2222-222222222222'::UUID],
    NOW() - INTERVAL '2 days'
) ON CONFLICT (id) DO NOTHING;

