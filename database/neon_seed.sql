-- ============================================================================
-- GLOBAL JOBS BY SUHANA — MENA MOBILE RECRUITMENT PLATFORM
-- NEON POSTGRESQL SEED DATA (USERS, CANDIDATE PROFILES & DOCUMENT VAULT)
-- ============================================================================

-- 1. Seed Demo Candidate User
INSERT INTO users (
    id, email, phone_country_code, phone_number, password_hash,
    full_name, avatar_url, preferred_language, is_phone_verified
) VALUES (
    '44444444-4444-4444-4444-444444444444',
    'ahmed.mansoor@example.com',
    '+20',
    '1012345678',
    crypt('AramcoHse2025!', gen_salt('bf')),
    'Ahmed Mansoor',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    'en',
    TRUE
) ON CONFLICT (id) DO NOTHING;

-- 2. Seed Candidate Profile
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
    8.0,
    5.0,
    96,
    TRUE,
    TRUE,
    15,
    'Transferable Iqama Available',
    30000.00,
    'SAR',
    'Senior HSE Professional with 8 years of offshore drilling safety supervision in the Red Sea and Arabian Gulf. Certified Saudi Aramco Work Permit Receiver (SAP-772918), NEBOSH IGC, and OPITO BOSIET.',
    'https://linkedin.com/in/ahmed-mansoor-hse'
) ON CONFLICT (id) DO NOTHING;

-- 3. Seed Document Vault: PASSPORT (ICAO Doc 9303 MRZ + Biometric Match)
INSERT INTO document_vault (
    id, user_id, document_type, file_name, file_url, file_size_bytes, mime_type, upload_source,
    passport_number, issuing_country, country_code_icao, passport_nationality,
    surname, given_names, date_of_birth, gender, issue_date, expiry_date,
    mrz_raw_line1, mrz_raw_line2, is_mrz_checksum_valid, face_id_match_score,
    is_verified, verification_status
) VALUES (
    '11111111-0000-0000-0000-000000000001',
    '44444444-4444-4444-4444-444444444444',
    'passport',
    'Egyptian_Passport_Ahmed_Mansoor.jpg',
    'https://neon-storage.example.com/vault/users/4444/passport_n8492014.enc',
    1450200,
    'image/jpeg',
    'manual',
    'N8492014',
    'Egypt',
    'EGY',
    'Egyptian',
    'MANSOOR',
    'AHMED',
    '1991-04-22',
    'M',
    '2022-03-10',
    '2029-03-09',
    'P<EGYMANSOOR<<AHMED<<<<<<<<<<<<<<<<<<<<<<<<<',
    'N8492014<8EGY9104225M2903091<<<<<<<<<<<<<<<2',
    TRUE,
    99.2,
    TRUE,
    'verified'
) ON CONFLICT (id) DO NOTHING;

-- 4. Seed Document Vault: CV / RESUME (With AI-Parsed JSON Payload)
INSERT INTO document_vault (
    id, user_id, document_type, file_name, file_url, file_size_bytes, mime_type, upload_source,
    is_primary_cv, extracted_full_text, parsed_data, is_verified, verification_status
) VALUES (
    '22222222-0000-0000-0000-000000000002',
    '44444444-4444-4444-4444-444444444444',
    'cv_resume',
    'Ahmed_Mansoor_HSE_Offshore_CV.pdf',
    'https://neon-storage.example.com/vault/users/4444/cv_ahmed_mansoor.pdf',
    420500,
    'application/pdf',
    'manual',
    TRUE,
    'AHMED MANSOOR — Senior HSE Offshore Supervisor. Certified Saudi Aramco Work Permit Receiver (SAP-772918). 8 Years experience in Offshore Jack-up Rigs and Oil & Gas EPC.',
    '{
        "fullName": "Ahmed Mansoor",
        "email": "ahmed.mansoor@example.com",
        "phone": "+201012345678",
        "nationality": "Egyptian",
        "residentCountry": "Saudi Arabia",
        "targetTitle": "Offshore HSE Supervisor",
        "totalExperience": 8.0,
        "gccExperience": 5.0,
        "experiences": [
            {
                "title": "Offshore HSE Officer / Work Permit Receiver",
                "company": "Arabian Drilling Company (ADC)",
                "country": "Saudi Arabia",
                "isGcc": true,
                "startDate": "2021-04-01",
                "isCurrent": true,
                "responsibilities": [
                    "Administer Saudi Aramco GI 0002.100 work permits across offshore rigs",
                    "Conduct daily toolbox safety talks and H2S contingency drills",
                    "Stop Work Authority enforcement and incident investigations"
                ]
            },
            {
                "title": "HSE Site Inspector",
                "company": "Petrojet Offshore Marine",
                "country": "Egypt",
                "isGcc": false,
                "startDate": "2016-08-01",
                "endDate": "2021-03-15",
                "isCurrent": false,
                "responsibilities": [
                    "Inspected pipeline fabrication and subsea structure lifting operations"
                ]
            }
        ],
        "education": [
            {
                "degree": "B.Sc. in Occupational Health & Environmental Safety",
                "field": "Environmental Safety",
                "institution": "Cairo University",
                "country": "Egypt",
                "graduationYear": 2016,
                "isMofaAttested": true
            }
        ],
        "skills": [
            "Saudi Aramco GI Protocols",
            "NEBOSH IGC",
            "Offshore Rig Safety",
            "BOSIET with CA-EBS",
            "H2S Awareness",
            "Incident Investigation"
        ]
    }'::JSONB,
    TRUE,
    'verified'
) ON CONFLICT (id) DO NOTHING;
