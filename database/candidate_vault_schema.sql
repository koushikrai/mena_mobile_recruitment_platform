-- ============================================================================
-- GLOBAL JOBS BY SUHANA — MENA MOBILE RECRUITMENT PLATFORM
-- CANDIDATE PROFILING & ENCRYPTED DOCUMENT VAULT SCHEMA (ATS-DECOUPLED)
-- ============================================================================
-- Architecture Note:
-- Companies, job listings, and quotas are fetched dynamically from the
-- central ATS website API. This schema handles candidate identity, career history,
-- verified credentials, ICAO 9303 passports, Aramco cards, and auto-attachment.
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- 1. ENUMS & DOMAIN TYPES
-- ============================================================================

DO $$ BEGIN
    CREATE TYPE user_role AS ENUM ('candidate', 'recruiter', 'admin');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE gcc_country_code AS ENUM ('uae', 'sau', 'qat', 'kwt', 'omn', 'bhr');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE currency_code AS ENUM ('AED', 'SAR', 'QAR', 'KWD', 'OMR', 'BHD', 'USD');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE relocation_stage AS ENUM (
        'applied',
        'screening',
        'interview',
        'offerIssued',
        'visaProcessing',
        'flightOnboarding'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE status_severity AS ENUM ('verified', 'review', 'critical', 'info');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE verification_status AS ENUM ('pending', 'verified', 'rejected', 'expired');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE document_category AS ENUM (
        'passport',
        'visa',
        'educationAttestation',
        'medicalGamca',
        'policeClearance',
        'tradeLicense',
        'aramcoCard',
        'healthLicence'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE reminder_channel AS ENUM ('push', 'whatsapp', 'email', 'sms');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE walkin_pass_status AS ENUM (
        'registered',
        'checked_in',
        'interviewed',
        'shortlisted',
        'cancelled'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- ============================================================================
-- 2. CANDIDATE IDENTITY & ACCOUNTS
-- ============================================================================

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_country_code VARCHAR(8) NOT NULL,       -- e.g. '+971', '+966', '+91', '+20'
    phone_number VARCHAR(20) UNIQUE NOT NULL,     -- Primary WhatsApp / Contact number
    password_hash VARCHAR(255) NOT NULL,
    role user_role NOT NULL DEFAULT 'candidate',
    full_name VARCHAR(150) NOT NULL,
    avatar_url TEXT,
    preferred_language VARCHAR(5) NOT NULL DEFAULT 'en', -- 'en' or 'ar'
    is_phone_verified BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- 3. CANDIDATE PROFILING & GCC READINESS
-- ============================================================================

CREATE TABLE IF NOT EXISTS candidate_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    target_job_title VARCHAR(150) NOT NULL,
    current_resident_country VARCHAR(100) NOT NULL,
    current_city VARCHAR(100) NOT NULL,
    nationality VARCHAR(100) NOT NULL,
    total_experience_years INT NOT NULL DEFAULT 0 CHECK (total_experience_years >= 0),
    gcc_experience_years INT NOT NULL DEFAULT 0 CHECK (gcc_experience_years >= 0),
    relocation_readiness_score INT NOT NULL DEFAULT 0 CHECK (relocation_readiness_score BETWEEN 0 AND 100),
    is_actively_looking BOOLEAN NOT NULL DEFAULT TRUE,
    is_gcc_verified BOOLEAN NOT NULL DEFAULT FALSE,
    notice_period_days INT NOT NULL DEFAULT 30,    -- 0 (Immediate), 15, 30, 60, 90
    relocation_status VARCHAR(100) NOT NULL DEFAULT 'Ready for Relocation',
    expected_salary_min NUMERIC(12, 2),
    expected_salary_currency currency_code NOT NULL DEFAULT 'SAR',
    bio TEXT,
    linkedin_url VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS candidate_preferred_countries (
    candidate_profile_id UUID NOT NULL REFERENCES candidate_profiles(id) ON DELETE CASCADE,
    country_code gcc_country_code NOT NULL,
    PRIMARY KEY (candidate_profile_id, country_code)
);

CREATE TABLE IF NOT EXISTS candidate_experiences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    candidate_profile_id UUID NOT NULL REFERENCES candidate_profiles(id) ON DELETE CASCADE,
    job_title VARCHAR(150) NOT NULL,
    company_name VARCHAR(150) NOT NULL,
    country VARCHAR(100) NOT NULL,
    is_gcc_experience BOOLEAN NOT NULL DEFAULT FALSE,
    start_date DATE NOT NULL,
    end_date DATE,                                -- NULL indicates 'Present'
    is_current BOOLEAN NOT NULL DEFAULT FALSE,
    responsibilities TEXT[] NOT NULL DEFAULT '{}',
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS candidate_educations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    candidate_profile_id UUID NOT NULL REFERENCES candidate_profiles(id) ON DELETE CASCADE,
    degree_title VARCHAR(150) NOT NULL,
    field_of_study VARCHAR(150) NOT NULL,
    institution_name VARCHAR(200) NOT NULL,
    country VARCHAR(100) NOT NULL,
    graduation_year INT NOT NULL CHECK (graduation_year BETWEEN 1960 AND 2035),
    is_mofa_attested BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS candidate_skills (
    candidate_profile_id UUID NOT NULL REFERENCES candidate_profiles(id) ON DELETE CASCADE,
    skill_name VARCHAR(100) NOT NULL,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (candidate_profile_id, skill_name)
);

-- ============================================================================
-- 4. ENCRYPTED DOCUMENT VAULT & BIOMETRIC VERIFICATION (ICAO DOC 9303)
-- ============================================================================

CREATE TABLE IF NOT EXISTS vault_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category document_category NOT NULL,
    title VARCHAR(200) NOT NULL,
    document_number VARCHAR(100) NOT NULL,
    issuing_country VARCHAR(100) NOT NULL,
    issue_date DATE,
    expiry_date DATE,
    is_valid_for_gcc_visa BOOLEAN NOT NULL DEFAULT FALSE,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    verification_status verification_status NOT NULL DEFAULT 'pending',
    file_url TEXT,
    file_size_bytes BIGINT,
    mime_type VARCHAR(100),
    encryption_key_ref VARCHAR(255),               -- AES-256 key ref
    reminder_6_months BOOLEAN NOT NULL DEFAULT TRUE,
    reminder_3_months BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS passport_mrz_data (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vault_document_id UUID UNIQUE NOT NULL REFERENCES vault_documents(id) ON DELETE CASCADE,
    passport_type VARCHAR(5) NOT NULL DEFAULT 'P',
    country_code_icao VARCHAR(5) NOT NULL,         -- 3-letter ICAO code e.g. 'IND', 'EGY', 'PAK', 'PHL'
    passport_number VARCHAR(50) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    given_names VARCHAR(150) NOT NULL,
    nationality_icao VARCHAR(5) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) NOT NULL,                   -- 'M', 'F', '<'
    expiry_date DATE NOT NULL,
    personal_number VARCHAR(50),
    mrz_raw_line1 VARCHAR(44) NOT NULL,
    mrz_raw_line2 VARCHAR(44) NOT NULL,
    is_checksum_valid BOOLEAN NOT NULL DEFAULT TRUE,
    has_six_months_validity BOOLEAN NOT NULL DEFAULT TRUE,
    face_id_match_score NUMERIC(5, 2) DEFAULT 98.0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS professional_certifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    vault_document_id UUID REFERENCES vault_documents(id) ON DELETE SET NULL,
    body_name VARCHAR(100) NOT NULL,               -- 'Saudi Aramco', 'NEBOSH', 'OPITO', 'SCE', 'DHA', 'MOH', 'SCFHS'
    certificate_name VARCHAR(200) NOT NULL,
    license_number VARCHAR(100) NOT NULL,
    issue_date DATE NOT NULL,
    expiry_date DATE,
    registry_verification_stamp VARCHAR(150),
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    verification_status verification_status NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS gcc_driving_licenses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    vault_document_id UUID REFERENCES vault_documents(id) ON DELETE SET NULL,
    country_code gcc_country_code NOT NULL,
    license_number VARCHAR(50) NOT NULL,
    classification VARCHAR(100) NOT NULL DEFAULT 'Light Vehicle (Manual/Auto)',
    issue_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    is_valid BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- 5. COMPLIANCE ENGINE & EXPIRY ALERTS (GCC 6-MONTH RULE & GAMCA 90-DAY)
-- ============================================================================

CREATE TABLE IF NOT EXISTS compliance_reminders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    vault_document_id UUID REFERENCES vault_documents(id) ON DELETE CASCADE,
    reminder_title VARCHAR(200) NOT NULL,
    reminder_message TEXT NOT NULL,
    channel reminder_channel NOT NULL DEFAULT 'push',
    trigger_date DATE NOT NULL,
    is_sent BOOLEAN NOT NULL DEFAULT FALSE,
    is_dismissed BOOLEAN NOT NULL DEFAULT FALSE,
    sent_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- 6. AI CV PARSER & WORK EXPERIENCE EXTRACTOR
-- ============================================================================

CREATE TABLE IF NOT EXISTS parsed_cv_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    original_filename VARCHAR(255) NOT NULL,
    file_storage_url TEXT NOT NULL,
    file_size_bytes BIGINT NOT NULL,
    extracted_full_text TEXT,
    parsed_json JSONB NOT NULL DEFAULT '{}'::JSONB,
    parsing_confidence_score NUMERIC(5, 2) DEFAULT 0.0 CHECK (parsing_confidence_score BETWEEN 0 AND 100),
    is_reviewed_by_candidate BOOLEAN NOT NULL DEFAULT FALSE,
    parsed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- 7. CANDIDATE ATS APPLICATIONS & AUTO-ATTACHED VAULT LINKAGE
-- ============================================================================
-- Decoupled from local jobs table: points directly to external ATS job identifiers!

CREATE TABLE IF NOT EXISTS candidate_applications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    ats_job_id VARCHAR(100) NOT NULL,             -- Unique job ID from main ATS website
    ats_job_reference VARCHAR(50) NOT NULL,       -- e.g. 'PG-HSE-908'
    job_title VARCHAR(200) NOT NULL,              -- Cached title for offline/fast UI
    company_name VARCHAR(150) NOT NULL,           -- Cached employer name
    country_code gcc_country_code NOT NULL,
    current_stage relocation_stage NOT NULL DEFAULT 'applied',
    status_label VARCHAR(100) NOT NULL DEFAULT 'Application Submitted',
    severity status_severity NOT NULL DEFAULT 'info',
    missing_documents TEXT[] DEFAULT '{}',
    cover_note TEXT,
    auto_attached_vault_cv VARCHAR(255),
    auto_attached_passport_num VARCHAR(50),
    attached_credential_ids UUID[] DEFAULT '{}',
    recruiter_contact VARCHAR(200),
    next_deadline TIMESTAMPTZ,
    applied_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_stage_updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, ats_job_id)
);

CREATE TABLE IF NOT EXISTS candidate_walkin_passes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    ats_drive_id VARCHAR(100) NOT NULL,           -- Drive ID from main ATS website
    drive_title VARCHAR(200) NOT NULL,
    selected_time_slot VARCHAR(50) NOT NULL,
    selected_venue VARCHAR(200) NOT NULL,
    qr_pass_code VARCHAR(100) UNIQUE NOT NULL,    -- Scannable entry pass
    status walkin_pass_status NOT NULL DEFAULT 'registered',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (ats_drive_id, user_id)
);

-- ============================================================================
-- 8. INDEXES & PERFORMANCE OPTIMIZATION
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone_country_code, phone_number);
CREATE INDEX IF NOT EXISTS idx_candidate_profiles_user_id ON candidate_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_candidate_experiences_profile ON candidate_experiences(candidate_profile_id);
CREATE INDEX IF NOT EXISTS idx_candidate_educations_profile ON candidate_educations(candidate_profile_id);
CREATE INDEX IF NOT EXISTS idx_vault_documents_user ON vault_documents(user_id);
CREATE INDEX IF NOT EXISTS idx_vault_documents_expiry ON vault_documents(expiry_date);
CREATE INDEX IF NOT EXISTS idx_professional_certifications_user ON professional_certifications(user_id);
CREATE INDEX IF NOT EXISTS idx_gcc_driving_licenses_user ON gcc_driving_licenses(user_id);
CREATE INDEX IF NOT EXISTS idx_candidate_applications_user ON candidate_applications(user_id);
CREATE INDEX IF NOT EXISTS idx_candidate_applications_ats_job ON candidate_applications(ats_job_id);
CREATE INDEX IF NOT EXISTS idx_candidate_walkin_user ON candidate_walkin_passes(user_id);

-- ============================================================================
-- 9. ROW LEVEL SECURITY (RLS) POLICIES — UAE & KSA PDPL
-- ============================================================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE candidate_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE candidate_experiences ENABLE ROW LEVEL SECURITY;
ALTER TABLE candidate_educations ENABLE ROW LEVEL SECURITY;
ALTER TABLE vault_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE passport_mrz_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE professional_certifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE gcc_driving_licenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE compliance_reminders ENABLE ROW LEVEL SECURITY;
ALTER TABLE parsed_cv_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE candidate_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE candidate_walkin_passes ENABLE ROW LEVEL SECURITY;

CREATE POLICY candidate_self_user_policy ON users
    FOR ALL USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

CREATE POLICY candidate_self_profile_policy ON candidate_profiles
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY candidate_self_vault_policy ON vault_documents
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY candidate_self_certs_policy ON professional_certifications
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY candidate_self_licenses_policy ON gcc_driving_licenses
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY candidate_self_applications_policy ON candidate_applications
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY candidate_self_walkin_policy ON candidate_walkin_passes
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY candidate_self_reminders_policy ON compliance_reminders
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY candidate_self_parsed_cv_policy ON parsed_cv_records
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
