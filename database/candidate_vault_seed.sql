-- ============================================================================
-- GLOBAL JOBS BY SUHANA — MENA MOBILE RECRUITMENT PLATFORM
-- SEED DATA: CANDIDATE PROFILING & ENCRYPTED DOCUMENT VAULT
-- ============================================================================

-- 1. Demo Candidates
INSERT INTO users (id, email, phone_country_code, phone_number, password_hash, role, full_name, avatar_url, preferred_language)
VALUES 
(
    '44444444-4444-4444-4444-444444444444',
    'ahmed.mansoor@example.com',
    '+20',
    '1012345678',
    crypt('AramcoHse2025!', gen_salt('bf')),
    'candidate',
    'Ahmed Mansoor',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    'en'
),
(
    '11111111-1111-1111-1111-111111111111',
    'koushik.candidate@example.com',
    '+971',
    '501234567',
    crypt('SecurePass123!', gen_salt('bf')),
    'candidate',
    'Koushik Rai',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
    'en'
)
ON CONFLICT (id) DO NOTHING;

-- 2. Ahmed Mansoor Candidate Profile
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
    'Senior HSE Professional with 8 years of offshore drilling safety supervision across Red Sea and Arabian Gulf platforms. Certified Saudi Aramco Work Permit Receiver (SAP-772918), NEBOSH IGC, and OPITO BOSIET.',
    'https://linkedin.com/in/ahmed-mansoor-hse'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO candidate_preferred_countries (candidate_profile_id, country_code)
VALUES 
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'sau'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'uae'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'qat')
ON CONFLICT DO NOTHING;

INSERT INTO candidate_experiences (
    id, candidate_profile_id, job_title, company_name, country,
    is_gcc_experience, start_date, end_date, is_current, responsibilities
) VALUES (
    'exp11111-1111-1111-1111-111111111111',
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    'Offshore HSE Officer / Permit Receiver',
    'Arabian Drilling Company (ADC)',
    'Saudi Arabia',
    TRUE,
    '2021-04-01',
    NULL,
    TRUE,
    ARRAY['Enforce Saudi Aramco GI 0002.100 work permits across offshore jack-up rigs', 'Execute daily toolbox safety talks and hydrogen sulfide (H2S) safety drills', 'Administer stop work authority (SWA) and safety observation reporting']
) ON CONFLICT (id) DO NOTHING;

INSERT INTO candidate_educations (
    id, candidate_profile_id, degree_title, field_of_study, institution_name, country, graduation_year, is_mofa_attested
) VALUES (
    'edu11111-1111-1111-1111-111111111111',
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    'B.Sc. in Occupational Health & Environmental Safety',
    'Environmental Sciences',
    'Cairo University',
    'Egypt',
    2016,
    TRUE
) ON CONFLICT (id) DO NOTHING;

INSERT INTO candidate_skills (candidate_profile_id, skill_name, is_verified)
VALUES 
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Saudi Aramco GI Protocols', TRUE),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'NEBOSH IGC', TRUE),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Offshore Rig Safety', TRUE),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'BOSIET with CA-EBS', TRUE),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'H2S Awareness', TRUE)
ON CONFLICT DO NOTHING;

-- 3. Ahmed Mansoor Encrypted Document Vault
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

-- MRZ Extraction
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

-- Professional Certifications
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

-- GCC Driving License
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

-- 4. Candidate Application Linked to Central ATS Job Reference
INSERT INTO candidate_applications (
    id, user_id, ats_job_id, ats_job_reference, job_title, company_name, country_code,
    current_stage, status_label, severity, missing_documents, cover_note,
    auto_attached_vault_cv, auto_attached_passport_num, attached_credential_ids,
    recruiter_contact, applied_date
) VALUES (
    'app22222-2222-2222-2222-222222222222',
    '44444444-4444-4444-4444-444444444444',
    'ats_job_pg_hse_908',
    'PG-HSE-908',
    'Senior Offshore HSE Supervisor',
    'PetroGulf Energy Consortium',
    'sau',
    'screening',
    'Application Under Review — Saudi Aramco Vendor Clearance',
    'verified',
    '{}',
    'Enclosed my verified profile with Saudi Aramco Approval Card (SAP-772918), valid NEBOSH certificate, and BOSIET for immediate offshore rotational mobilization.',
    'Ahmed_Mansoor_HSE_Offshore_CV.pdf',
    'N8492014',
    ARRAY['cert1111-1111-1111-1111-111111111111'::UUID, 'cert2222-2222-2222-2222-222222222222'::UUID],
    'Tariq Al-Zahrani via WhatsApp (+966555123456)',
    NOW() - INTERVAL '2 days'
) ON CONFLICT (id) DO NOTHING;

-- 5. Candidate Walk-in Pass Linked to Central ATS Walk-in Drive
INSERT INTO candidate_walkin_passes (
    id, user_id, ats_drive_id, drive_title, selected_time_slot, selected_venue, qr_pass_code, status
) VALUES (
    'reg11111-1111-1111-1111-111111111111',
    '44444444-4444-4444-4444-444444444444',
    'ats_drive_yanbu_jubail_2025',
    'Mega Walk-In Recruitment Drive 2025 — Yanbu & Jubail Industrial Cities',
    '09:00 AM - 11:00 AM (Priority Pass)',
    'Yanbu Industrial City — Royal Commission Convention Centre, Hall B',
    'MENA-PASS-YNB-2025-9912',
    'registered'
) ON CONFLICT (id) DO NOTHING;
