-- ============================================================================
-- GLOBAL JOBS BY SUHANA — MENA MOBILE RECRUITMENT PLATFORM
-- NEON POSTGRESQL SCHEMA (USERS, CANDIDATE PROFILES & DOCUMENT VAULT)
-- ============================================================================
-- Specifically streamlined for Neon Serverless Postgres.
-- Document Vault strictly contains: 'passport' and 'cv_resume'.
-- Companies and Job listings are fetched dynamically from the main ATS website.
-- ============================================================================

-- Enable pgcrypto for password hashing if needed
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- 1. USERS (Candidate Accounts & Identity)
-- ============================================================================

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_country_code VARCHAR(8) NOT NULL,            -- e.g. '+966', '+971', '+20', '+91'
    phone_number VARCHAR(20) UNIQUE NOT NULL,          -- Primary WhatsApp / contact number
    password_hash VARCHAR(255) NOT NULL,               -- Bcrypt / Argon2 hashed
    full_name VARCHAR(150) NOT NULL,
    avatar_url TEXT,
    preferred_language VARCHAR(5) NOT NULL DEFAULT 'en', -- 'en' or 'ar'
    is_phone_verified BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- 2. CANDIDATE PROFILES (GCC Relocation Readiness & Career Specs)
-- ============================================================================

CREATE TABLE IF NOT EXISTS candidate_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    target_job_title VARCHAR(150) NOT NULL,            -- e.g. 'Offshore HSE Supervisor'
    current_resident_country VARCHAR(100) NOT NULL,
    current_city VARCHAR(100) NOT NULL,
    nationality VARCHAR(100) NOT NULL,
    total_experience_years NUMERIC(4, 1) NOT NULL DEFAULT 0.0 CHECK (total_experience_years >= 0),
    gcc_experience_years NUMERIC(4, 1) NOT NULL DEFAULT 0.0 CHECK (gcc_experience_years >= 0),
    relocation_readiness_score INT NOT NULL DEFAULT 0 CHECK (relocation_readiness_score BETWEEN 0 AND 100),
    is_actively_looking BOOLEAN NOT NULL DEFAULT TRUE,
    is_gcc_verified BOOLEAN NOT NULL DEFAULT FALSE,
    notice_period_days INT NOT NULL DEFAULT 30,         -- 0 (Immediate), 15, 30, 60, 90
    relocation_status VARCHAR(100) NOT NULL DEFAULT 'Ready for Relocation',
    expected_salary_min NUMERIC(12, 2),
    expected_salary_currency VARCHAR(10) NOT NULL DEFAULT 'SAR', -- 'SAR', 'AED', 'QAR', 'USD'
    bio TEXT,
    linkedin_url VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- 3. DOCUMENT VAULT (Strictly Passport & CV / Resume Only)
-- ============================================================================

CREATE TABLE IF NOT EXISTS document_vault (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Restricted strictly to 'passport' and 'cv_resume'
    document_type VARCHAR(20) NOT NULL CHECK (document_type IN ('passport', 'cv_resume')),
    
    -- Common Document Metadata
    file_name VARCHAR(255) NOT NULL,                   -- e.g. 'Ahmed_Mansoor_HSE_CV.pdf', 'passport_scan.jpg'
    file_url TEXT NOT NULL,                            -- Cloud Storage / S3 / Neon blob URL
    file_size_bytes BIGINT,
    mime_type VARCHAR(100) NOT NULL,                   -- 'application/pdf', 'image/jpeg', 'image/png'
    upload_source VARCHAR(50) NOT NULL DEFAULT 'manual' CHECK (upload_source IN ('manual', 'whatsapp', 'linkedin')),
    
    -- ------------------------------------------------------------------------
    -- PASSPORT SPECIFIC FIELDS (Populated when document_type = 'passport')
    -- ------------------------------------------------------------------------
    passport_number VARCHAR(50),                       -- e.g. 'N8492014'
    issuing_country VARCHAR(100),                      -- e.g. 'Egypt', 'India', 'Pakistan'
    country_code_icao VARCHAR(5),                      -- 3-letter ICAO code: 'EGY', 'IND', 'PAK', 'PHL'
    passport_nationality VARCHAR(100),
    surname VARCHAR(100),
    given_names VARCHAR(150),
    date_of_birth DATE,
    gender VARCHAR(10),                                -- 'M', 'F', '<'
    issue_date DATE,
    expiry_date DATE,
    
    -- Optical MRZ Scanner Fields (ICAO Doc 9303 TD3 standard)
    mrz_raw_line1 VARCHAR(44),                         -- e.g. 'P<EGYMANSOOR<<AHMED<<<<<<<<<<<<<<<<<<<<<<<<<'
    mrz_raw_line2 VARCHAR(44),                         -- e.g. 'N8492014<8EGY9104225M2903091<<<<<<<<<<<<<<<2'
    is_mrz_checksum_valid BOOLEAN DEFAULT TRUE,
    
    -- MENA Regulatory Rule: Must have >= 6 months validity from today
    has_six_months_validity BOOLEAN DEFAULT TRUE,
    face_id_match_score NUMERIC(5, 2) DEFAULT 98.0,    -- Selfie biometrics match % (0.0 to 100.0)
    
    -- ------------------------------------------------------------------------
    -- CV / RESUME SPECIFIC FIELDS (Populated when document_type = 'cv_resume')
    -- ------------------------------------------------------------------------
    extracted_full_text TEXT,                          -- Raw text extracted by OCR / PDF parser
    parsed_data JSONB DEFAULT '{}'::JSONB,             -- AI structured JSON: experiences, education, skills
    is_primary_cv BOOLEAN DEFAULT TRUE,                -- Default CV selected for 1-Tap Apply to ATS
    
    -- ------------------------------------------------------------------------
    -- VERIFICATION STATUS & AUDIT
    -- ------------------------------------------------------------------------
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    verification_status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (verification_status IN ('pending', 'verified', 'rejected', 'expired')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT check_passport_fields CHECK (
        (document_type = 'passport' AND passport_number IS NOT NULL AND expiry_date IS NOT NULL) OR
        (document_type = 'cv_resume')
    )
);

-- ============================================================================
-- 4. PERFORMANCE INDEXES
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone_country_code, phone_number);

CREATE INDEX IF NOT EXISTS idx_candidate_profiles_user ON candidate_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_candidate_profiles_readiness ON candidate_profiles(relocation_readiness_score DESC);

CREATE INDEX IF NOT EXISTS idx_document_vault_user_type ON document_vault(user_id, document_type);
CREATE INDEX IF NOT EXISTS idx_document_vault_passport_num ON document_vault(passport_number) WHERE document_type = 'passport';
CREATE INDEX IF NOT EXISTS idx_document_vault_primary_cv ON document_vault(user_id, is_primary_cv) WHERE document_type = 'cv_resume';
CREATE INDEX IF NOT EXISTS idx_document_vault_expiry ON document_vault(expiry_date) WHERE document_type = 'passport';

-- ============================================================================
-- 5. AUTOMATIC TRIGGERS (TIMESTAMP & 6-MONTH PASSPORT VALIDITY)
-- ============================================================================

-- Function 1: Automatically maintain updated_at
CREATE OR REPLACE FUNCTION trigger_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at_users
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();

CREATE TRIGGER set_updated_at_candidate_profiles
BEFORE UPDATE ON candidate_profiles
FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();

CREATE TRIGGER set_updated_at_document_vault
BEFORE UPDATE ON document_vault
FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();

-- Function 2: Automatically calculate 6-month GCC passport validity
CREATE OR REPLACE FUNCTION trigger_calculate_passport_validity()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.document_type = 'passport' AND NEW.expiry_date IS NOT NULL THEN
        NEW.has_six_months_validity := (NEW.expiry_date >= (CURRENT_DATE + INTERVAL '180 days'));
        IF NEW.has_six_months_validity = FALSE THEN
            NEW.verification_status := 'expired';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER calculate_passport_validity_vault
BEFORE INSERT OR UPDATE OF expiry_date, document_type ON document_vault
FOR EACH ROW EXECUTE FUNCTION trigger_calculate_passport_validity();
