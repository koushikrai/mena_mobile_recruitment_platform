-- ============================================================================
-- GLOBAL JOBS BY SUHANA — MENA MOBILE RECRUITMENT PLATFORM
-- PRODUCTION DATABASE SCHEMA (PostgreSQL / Supabase Compatible)
-- Compliant with UAE PDPL & KSA PDPL Data Protection Standards
-- ============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- 1. ENUMS & DOMAIN TYPES
-- ============================================================================

CREATE TYPE user_role AS ENUM (
    'candidate',
    'employer',
    'recruiter',
    'admin'
);

CREATE TYPE gcc_country_code AS ENUM (
    'uae', -- United Arab Emirates
    'sau', -- Kingdom of Saudi Arabia
    'qat', -- Qatar
    'kwt', -- Kuwait
    'omn', -- Oman
    'bhr'  -- Bahrain
);

CREATE TYPE currency_code AS ENUM (
    'AED',
    'SAR',
    'QAR',
    'KWD',
    'OMR',
    'BHD',
    'USD'
);

CREATE TYPE relocation_stage AS ENUM (
    'applied',
    'screening',
    'interview',
    'offerIssued',
    'visaProcessing',
    'flightOnboarding',
    'hired',
    'rejected',
    'withdrawn'
);

CREATE TYPE status_severity AS ENUM (
    'verified',
    'review',
    'critical',
    'info'
);

CREATE TYPE document_category AS ENUM (
    'passport',
    'visa',
    'educationAttestation',
    'medicalGamca',
    'policeClearance',
    'tradeLicense',
    'experienceCert',
    'drivingLicense',
    'aramcoCard',
    'healthLicence'
);

CREATE TYPE walkin_pass_status AS ENUM (
    'registered',
    'checked_in',
    'interviewed',
    'shortlisted',
    'cancelled'
);

CREATE TYPE visa_status_type AS ENUM (
    'Fully Sponsored',
    'Transferable Iqama',
    'Green Visa',
    'Golden Visa',
    'Work Permit',
    'Visit Visa'
);

CREATE TYPE accommodation_type AS ENUM (
    'Provided',
    'Housing Allowance',
    'Not Included'
);

CREATE TYPE verification_status AS ENUM (
    'pending',
    'in_review',
    'verified',
    'rejected',
    'expired'
);

CREATE TYPE reminder_channel AS ENUM (
    'push',
    'whatsapp',
    'email',
    'sms',
    'in_app'
);

-- ============================================================================
-- 2. USERS & AUTHENTICATION
-- ============================================================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_country_code VARCHAR(8) NOT NULL, -- e.g., '+971', '+966', '+91'
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role user_role NOT NULL DEFAULT 'candidate',
    full_name VARCHAR(150) NOT NULL,
    avatar_url TEXT,
    preferred_language VARCHAR(5) NOT NULL DEFAULT 'en', -- 'en' or 'ar'
    is_phone_verified BOOLEAN NOT NULL DEFAULT FALSE,
    is_email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- 3. CANDIDATE PROFILES & EXPERIENCES
-- ============================================================================

CREATE TABLE candidate_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    target_job_title VARCHAR(150),
    current_resident_country VARCHAR(100) NOT NULL,
    current_city VARCHAR(100) NOT NULL,
    nationality VARCHAR(100) NOT NULL,
    total_experience_years INT NOT NULL DEFAULT 0,
    gcc_experience_years INT NOT NULL DEFAULT 0,
    relocation_readiness_score INT NOT NULL DEFAULT 0 CHECK (relocation_readiness_score BETWEEN 0 AND 100),
    is_actively_looking BOOLEAN NOT NULL DEFAULT TRUE,
    is_gcc_verified BOOLEAN NOT NULL DEFAULT FALSE,
    notice_period_days INT NOT NULL DEFAULT 30, -- e.g. 0 (Immediate), 30, 60, 90
    relocation_status VARCHAR(50) NOT NULL DEFAULT 'Ready to Relocate',
    expected_salary_min NUMERIC(12, 2),
    expected_salary_currency currency_code NOT NULL DEFAULT 'AED',
    linkedin_url VARCHAR(255),
    bio TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE candidate_preferred_countries (
    candidate_profile_id UUID NOT NULL REFERENCES candidate_profiles(id) ON DELETE CASCADE,
    country_code gcc_country_code NOT NULL,
    PRIMARY KEY (candidate_profile_id, country_code)
);

CREATE TABLE candidate_experiences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    candidate_profile_id UUID NOT NULL REFERENCES candidate_profiles(id) ON DELETE CASCADE,
    job_title VARCHAR(150) NOT NULL,
    company_name VARCHAR(150) NOT NULL,
    country VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    is_gcc_experience BOOLEAN NOT NULL DEFAULT FALSE,
    start_date DATE NOT NULL,
    end_date DATE, -- NULL if current
    is_current BOOLEAN NOT NULL DEFAULT FALSE,
    responsibilities TEXT[] NOT NULL DEFAULT '{}',
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE candidate_educations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    candidate_profile_id UUID NOT NULL REFERENCES candidate_profiles(id) ON DELETE CASCADE,
    institution_name VARCHAR(200) NOT NULL,
    degree VARCHAR(150) NOT NULL,
    field_of_study VARCHAR(150) NOT NULL,
    country VARCHAR(100) NOT NULL,
    graduation_year INT NOT NULL,
    is_mofa_attested BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE candidate_skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    candidate_profile_id UUID NOT NULL REFERENCES candidate_profiles(id) ON DELETE CASCADE,
    skill_name VARCHAR(100) NOT NULL,
    years_of_experience INT DEFAULT 1,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (candidate_profile_id, skill_name)
);

-- ============================================================================
-- 4. EMPLOYERS & COMPANIES
-- ============================================================================

CREATE TABLE companies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    name VARCHAR(200) NOT NULL,
    name_ar VARCHAR(200),
    logo_url TEXT,
    industry VARCHAR(100) NOT NULL, -- e.g. Construction, Healthcare, Oil & Gas
    country_code gcc_country_code NOT NULL,
    city VARCHAR(100) NOT NULL,
    headquarters_address TEXT,
    website VARCHAR(255),
    commercial_reg_number VARCHAR(100), -- Trade License / CR Number
    is_mofa_registered BOOLEAN NOT NULL DEFAULT TRUE,
    is_mhrsd_licensed BOOLEAN NOT NULL DEFAULT TRUE,
    is_verified_employer BOOLEAN NOT NULL DEFAULT FALSE,
    company_size VARCHAR(50) DEFAULT '500-1000 employees',
    about_description TEXT,
    recruiter_contact_name VARCHAR(150),
    recruiter_contact_email VARCHAR(255),
    recruiter_whatsapp VARCHAR(50),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- 5. JOBS, SECTORS & REQUIREMENTS
-- ============================================================================

CREATE TABLE jobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    reference_code VARCHAR(50) UNIQUE NOT NULL DEFAULT 'REF: ' || SUBSTRING(gen_random_uuid()::text, 1, 8),
    title VARCHAR(200) NOT NULL,
    department VARCHAR(100) NOT NULL,
    sector VARCHAR(100) NOT NULL DEFAULT 'Oil & Gas',
    country_code gcc_country_code NOT NULL,
    city VARCHAR(100) NOT NULL,
    employment_type VARCHAR(50) NOT NULL DEFAULT 'Full-Time Expat',
    rotation_schedule VARCHAR(100) DEFAULT '28 Days On / 28 Days Off',
    salary_min NUMERIC(12, 2) NOT NULL,
    salary_max NUMERIC(12, 2) NOT NULL,
    currency currency_code NOT NULL DEFAULT 'SAR',
    is_tax_free BOOLEAN NOT NULL DEFAULT TRUE,
    visa_status visa_status_type NOT NULL DEFAULT 'Fully Sponsored',
    visa_allocation_covered BOOLEAN NOT NULL DEFAULT TRUE,
    accommodation accommodation_type NOT NULL DEFAULT 'Provided',
    food_allowance_provided BOOLEAN NOT NULL DEFAULT TRUE,
    annual_flights_provided BOOLEAN NOT NULL DEFAULT TRUE,
    relocation_benefits TEXT[] DEFAULT '{}', -- ['Flight Included', 'Family Visa', 'End of Service Gratuity']
    is_direct_employer BOOLEAN NOT NULL DEFAULT TRUE,
    is_fast_track_mobilization BOOLEAN NOT NULL DEFAULT TRUE,
    pre_deployment_fee_amount NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    cryptographic_stamp VARCHAR(150),
    mofa_attestation_required BOOLEAN NOT NULL DEFAULT TRUE,
    gamca_medical_required BOOLEAN NOT NULL DEFAULT TRUE,
    iqama_transferable BOOLEAN NOT NULL DEFAULT FALSE,
    police_clearance_required BOOLEAN NOT NULL DEFAULT TRUE,
    application_deadline TIMESTAMPTZ NOT NULL,
    required_languages VARCHAR(100) NOT NULL DEFAULT 'English',
    job_description TEXT NOT NULL,
    responsibilities TEXT[] NOT NULL DEFAULT '{}',
    qualifications TEXT[] NOT NULL DEFAULT '{}',
    required_skills TEXT[] NOT NULL DEFAULT '{}',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    posted_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE job_bookmarks (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, job_id)
);

-- ============================================================================
-- 6. WALK-IN RECRUITMENT DRIVES & FAST-TRACK PASSES
-- ============================================================================

CREATE TABLE walkin_drives (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    job_id UUID REFERENCES jobs(id) ON DELETE SET NULL,
    drive_title VARCHAR(200) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    venues TEXT[] NOT NULL DEFAULT '{}',
    total_quota_vacancies INT NOT NULL DEFAULT 1200,
    required_documents TEXT[] NOT NULL DEFAULT '{}',
    available_time_slots TEXT[] NOT NULL DEFAULT '{}',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE walkin_registrations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    drive_id UUID NOT NULL REFERENCES walkin_drives(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    selected_time_slot VARCHAR(50) NOT NULL,
    selected_venue VARCHAR(200) NOT NULL,
    qr_pass_code VARCHAR(100) UNIQUE NOT NULL,
    status walkin_pass_status NOT NULL DEFAULT 'registered',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (drive_id, user_id)
);

-- ============================================================================
-- 6. APPLICATIONS & 6-STAGE RELOCATION PIPELINE
-- ============================================================================

CREATE TABLE job_applications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE RESTRICT,
    current_stage relocation_stage NOT NULL DEFAULT 'applied',
    status_label VARCHAR(100) NOT NULL DEFAULT 'Application Submitted',
    severity status_severity NOT NULL DEFAULT 'info',
    missing_documents TEXT[] DEFAULT '{}',
    next_deadline TIMESTAMPTZ,
    recruiter_contact VARCHAR(200),
    cover_note TEXT,
    auto_attached_vault_cv VARCHAR(255),
    auto_attached_passport_num VARCHAR(50),
    attached_credential_ids UUID[] DEFAULT '{}',
    applied_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_stage_updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, job_id)
);

CREATE TABLE application_timeline_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID NOT NULL REFERENCES job_applications(id) ON DELETE CASCADE,
    stage relocation_stage NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    event_status VARCHAR(50) NOT NULL DEFAULT 'completed', -- 'completed', 'in_progress', 'pending'
    actor_type VARCHAR(50) NOT NULL DEFAULT 'system', -- 'candidate', 'employer', 'system'
    event_timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    metadata JSONB DEFAULT '{}'::JSONB
);

-- Specific stage tracking details:
CREATE TABLE visa_processing_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID UNIQUE NOT NULL REFERENCES job_applications(id) ON DELETE CASCADE,
    mofa_reference_number VARCHAR(100),
    entry_permit_number VARCHAR(100),
    visa_type VARCHAR(100) NOT NULL DEFAULT 'Employment Visa',
    gamca_medical_center VARCHAR(200),
    gamca_fit_status BOOLEAN,
    gamca_report_url TEXT,
    entry_permit_issue_date DATE,
    entry_permit_expiry_date DATE,
    e_visa_pdf_url TEXT,
    status verification_status NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE flight_relocation_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID UNIQUE NOT NULL REFERENCES job_applications(id) ON DELETE CASCADE,
    airline VARCHAR(100) NOT NULL,
    flight_number VARCHAR(50) NOT NULL,
    pnr_number VARCHAR(20) NOT NULL,
    departure_airport_code VARCHAR(10) NOT NULL,
    arrival_airport_code VARCHAR(10) NOT NULL,
    departure_time TIMESTAMPTZ NOT NULL,
    arrival_time TIMESTAMPTZ NOT NULL,
    ticket_pdf_url TEXT,
    airport_pickup_contact_name VARCHAR(150),
    airport_pickup_contact_phone VARCHAR(50),
    temporary_housing_address TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- 7. DOCUMENT VAULT & AES-256 COMPLIANCE (ICAO 9303 MRZ OCR)
-- ============================================================================

CREATE TABLE vault_documents (
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
    encryption_key_ref VARCHAR(255), -- Key derivation identifier (AES-256)
    reminder_6_months BOOLEAN NOT NULL DEFAULT TRUE,
    reminder_3_months BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE passport_mrz_data (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vault_document_id UUID UNIQUE NOT NULL REFERENCES vault_documents(id) ON DELETE CASCADE,
    passport_type VARCHAR(5) NOT NULL DEFAULT 'P',
    country_code_icao VARCHAR(5) NOT NULL, -- 3-letter ICAO e.g. 'IND', 'PAK', 'PHL', 'EGY'
    passport_number VARCHAR(50) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    given_names VARCHAR(150) NOT NULL,
    nationality_icao VARCHAR(5) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) NOT NULL, -- 'M', 'F', '<'
    expiry_date DATE NOT NULL,
    personal_number VARCHAR(50),
    mrz_raw_line1 VARCHAR(44) NOT NULL,
    mrz_raw_line2 VARCHAR(44) NOT NULL,
    is_checksum_valid BOOLEAN NOT NULL DEFAULT TRUE,
    has_six_months_validity BOOLEAN NOT NULL DEFAULT TRUE,
    face_id_match_score NUMERIC(5, 2) DEFAULT 98.0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE professional_certifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    vault_document_id UUID REFERENCES vault_documents(id) ON DELETE SET NULL,
    body_name VARCHAR(100) NOT NULL, -- 'Saudi Aramco', 'SCE', 'NEBOSH', 'OPITO', 'OSHA', 'DHA', 'MOH', 'SCFHS'
    certificate_name VARCHAR(200) NOT NULL,
    license_number VARCHAR(100) NOT NULL,
    issue_date DATE NOT NULL,
    expiry_date DATE,
    registry_verification_stamp VARCHAR(150),
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    verification_status verification_status NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE gcc_driving_licenses (
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
-- 8. COMPLIANCE REMINDERS & REGULATORY ALERTS
-- ============================================================================

CREATE TABLE compliance_reminders (
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
-- 9. AI CV PARSER RECORDS
-- ============================================================================

CREATE TABLE parsed_cv_records (
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
-- 10. PERFORMANCE INDEXES
-- ============================================================================

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone_country_code, phone_number);

CREATE INDEX idx_candidate_profiles_user_id ON candidate_profiles(user_id);
CREATE INDEX idx_candidate_profiles_readiness ON candidate_profiles(relocation_readiness_score DESC);

CREATE INDEX idx_jobs_country_city ON jobs(country_code, city);
CREATE INDEX idx_jobs_is_active ON jobs(is_active);
CREATE INDEX idx_jobs_salary ON jobs(salary_min, salary_max);
CREATE INDEX idx_jobs_company_id ON jobs(company_id);

CREATE INDEX idx_job_applications_user ON job_applications(user_id);
CREATE INDEX idx_job_applications_job ON job_applications(job_id);
CREATE INDEX idx_job_applications_stage ON job_applications(current_stage);

CREATE INDEX idx_vault_documents_user ON vault_documents(user_id);
CREATE INDEX idx_vault_documents_expiry ON vault_documents(expiry_date);
CREATE INDEX idx_compliance_reminders_trigger ON compliance_reminders(trigger_date, is_sent);

-- ============================================================================
-- 11. AUTOMATIC TRIGGERS & BUSINESS LOGIC
-- ============================================================================

-- Automatically update `updated_at` column timestamp
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_timestamp_users
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER set_timestamp_candidate_profiles
BEFORE UPDATE ON candidate_profiles
FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER set_timestamp_companies
BEFORE UPDATE ON companies
FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER set_timestamp_jobs
BEFORE UPDATE ON jobs
FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER set_timestamp_job_applications
BEFORE UPDATE ON job_applications
FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER set_timestamp_vault_documents
BEFORE UPDATE ON vault_documents
FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();

-- ============================================================================
-- 12. ROW LEVEL SECURITY (RLS) POLICIES — PDPL COMPLIANCE
-- ============================================================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE candidate_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE candidate_experiences ENABLE ROW LEVEL SECURITY;
ALTER TABLE candidate_educations ENABLE ROW LEVEL SECURITY;
ALTER TABLE vault_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE passport_mrz_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE professional_certifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE gcc_driving_licenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE walkin_drives ENABLE ROW LEVEL SECURITY;
ALTER TABLE walkin_registrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE compliance_reminders ENABLE ROW LEVEL SECURITY;
ALTER TABLE parsed_cv_records ENABLE ROW LEVEL SECURITY;

-- Candidates can view and edit their own profile data
CREATE POLICY candidate_profile_policy ON candidate_profiles
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY candidate_experiences_policy ON candidate_experiences
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY candidate_educations_policy ON candidate_educations
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Candidates can only view and manage their own vault documents & credentials
CREATE POLICY candidate_vault_policy ON vault_documents
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY candidate_certifications_policy ON professional_certifications
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY candidate_driving_licenses_policy ON gcc_driving_licenses
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Candidates can only view and manage their own applications
CREATE POLICY candidate_application_policy ON job_applications
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Public jobs are viewable by all active candidates
CREATE POLICY public_jobs_policy ON jobs
    FOR SELECT USING (is_active = TRUE);

-- Active walk-in drives are viewable by all candidates
CREATE POLICY public_walkin_drives_policy ON walkin_drives
    FOR SELECT USING (is_active = TRUE);

-- Candidates can manage their own walk-in registrations
CREATE POLICY candidate_walkin_registrations_policy ON walkin_registrations
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Candidates can view their own compliance reminders
CREATE POLICY candidate_reminders_policy ON compliance_reminders
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Candidates can view and update their own parsed CVs
CREATE POLICY candidate_parsed_cv_policy ON parsed_cv_records
    FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

