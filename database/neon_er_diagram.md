# MENA Mobile Recruitment Platform — Database ER Diagram
## Neon PostgreSQL Architecture (Users, Candidate Profiles & Document Vault)

```mermaid
erDiagram
    USERS ||--|| CANDIDATE_PROFILES : "1-to-1: has profile"
    USERS ||--o{ DOCUMENT_VAULT : "1-to-many: stores documents"

    USERS {
        uuid id PK "gen_random_uuid()"
        varchar email UK "Candidate Login Email"
        varchar phone_country_code "+966, +971, +20, +91"
        varchar phone_number UK "WhatsApp / Mobile"
        varchar password_hash "Bcrypt / Argon2"
        varchar full_name "Legal Name"
        text avatar_url "Profile Photo"
        varchar preferred_language "en or ar"
        boolean is_phone_verified "OTP Verification"
        boolean is_active "Account Status"
        timestamptz created_at "NOW()"
        timestamptz updated_at "Auto-Trigger"
    }

    CANDIDATE_PROFILES {
        uuid id PK "gen_random_uuid()"
        uuid user_id FK "UNIQUE -> users(id)"
        varchar target_job_title "e.g. Offshore HSE Supervisor"
        varchar current_resident_country "Current Residence"
        varchar current_city "e.g. Al Khobar, Dubai"
        varchar nationality "Passport Nationality"
        numeric total_experience_years "Career Years"
        numeric gcc_experience_years "GCC Verified Track Record"
        int relocation_readiness_score "0 to 100%"
        boolean is_actively_looking "Availability Flag"
        boolean is_gcc_verified "GCC Background Check"
        int notice_period_days "0 (Immediate), 15, 30, 60"
        varchar relocation_status "e.g. Transferable Iqama Available"
        numeric expected_salary_min "Baseline Salary"
        varchar expected_salary_currency "SAR, AED, USD"
        text bio "Professional Summary"
        varchar linkedin_url "LinkedIn Profile URL"
        timestamptz created_at "NOW()"
        timestamptz updated_at "Auto-Trigger"
    }

    DOCUMENT_VAULT {
        uuid id PK "gen_random_uuid()"
        uuid user_id FK "-> users(id)"
        varchar document_type "DISCRIMINATOR: 'passport' | 'cv_resume'"
        varchar file_name "Original Filename"
        text file_url "Storage URL / S3 Path"
        bigint file_size_bytes "Size in Bytes"
        varchar mime_type "application/pdf, image/jpeg"
        varchar upload_source "'manual' | 'whatsapp' | 'linkedin'"
        
        %% PASSPORT SPECIFIC ATTRIBUTES
        varchar passport_number "Passport No (e.g. N8492014)"
        varchar issuing_country "Issuing State"
        varchar country_code_icao "3-letter ICAO (EGY, IND, PAK)"
        varchar passport_nationality "Nationality"
        varchar surname "Legal Surname"
        varchar given_names "Given Names"
        date date_of_birth "Date of Birth"
        varchar gender "M, F"
        date issue_date "Issue Date"
        date expiry_date "Expiration Date"
        varchar mrz_raw_line1 "ICAO Doc 9303 Line 1 (44 chars)"
        varchar mrz_raw_line2 "ICAO Doc 9303 Line 2 (44 chars)"
        boolean is_mrz_checksum_valid "MRZ Check Digit Valid"
        boolean has_six_months_validity "Computed Trigger: >= 180 Days"
        numeric face_id_match_score "Biometric Match % (0-100)"
        
        %% CV / RESUME SPECIFIC ATTRIBUTES
        text extracted_full_text "Full OCR/PDF Text"
        jsonb parsed_data "AI JSON: Experiences, Education, Skills"
        boolean is_primary_cv "Default for 1-Tap ATS Apply"
        
        %% AUDIT & VERIFICATION
        boolean is_verified "Manual/System Verified"
        varchar verification_status "'pending' | 'verified' | 'rejected' | 'expired'"
        timestamptz created_at "NOW()"
        timestamptz updated_at "Auto-Trigger"
    }
```

---

## Relationship Breakdown & Constraints

| From Table | To Table | Relationship | Cardinality | Delete Action | Business Rule |
|---|---|---|---|---|---|
| `users` | `candidate_profiles` | `has_profile` | **1 : 1** | `ON DELETE CASCADE` | Every candidate has exactly one master career profile. |
| `users` | `document_vault` | `stores_documents` | **1 : N** | `ON DELETE CASCADE` | A user can upload their verified Passport and one or more CV/Resumes. |

---

## Architectural Notes for Neon & ATS Integration

1. **Table Discrimination in `document_vault`**:
   - `document_type = 'passport'` activates the ICAO Doc 9303 travel compliance fields (`mrz_raw_line1/2`, `face_id_match_score`, `has_six_months_validity`).
   - `document_type = 'cv_resume'` activates the ATS extraction fields (`parsed_data JSONB`, `extracted_full_text`, `is_primary_cv`).

2. **Automated GCC Visa Validity Trigger**:
   - Every passport record is continuously audited by `trigger_calculate_passport_validity()`. If `expiry_date < CURRENT_DATE + INTERVAL '180 days'`, `has_six_months_validity` turns `FALSE` and status is marked `expired`.

3. **External ATS Bridge**:
   - When candidates apply to jobs fetched from the main ATS website, the mobile app passes:
     - `candidate_profiles.id`
     - `document_vault.file_url` (where `document_type = 'cv_resume'` AND `is_primary_cv = true`)
     - `document_vault.passport_number` and `has_six_months_validity` (where `document_type = 'passport'`)
