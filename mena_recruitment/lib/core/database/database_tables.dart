/// Type-safe database table and column contract for MENA Mobile Recruitment Platform.
class DatabaseTables {
  DatabaseTables._();

  // Table Names
  static const String users = 'users';
  static const String candidateProfiles = 'candidate_profiles';
  static const String candidatePreferredCountries = 'candidate_preferred_countries';
  static const String candidateExperiences = 'candidate_experiences';
  static const String candidateEducations = 'candidate_educations';
  static const String candidateSkills = 'candidate_skills';
  static const String companies = 'companies';
  static const String jobs = 'jobs';
  static const String jobBookmarks = 'job_bookmarks';
  static const String jobApplications = 'job_applications';
  static const String applicationTimelineEvents = 'application_timeline_events';
  static const String visaProcessingRecords = 'visa_processing_records';
  static const String flightRelocationRecords = 'flight_relocation_records';
  static const String vaultDocuments = 'vault_documents';
  static const String passportMrzData = 'passport_mrz_data';
  static const String professionalCertifications = 'professional_certifications';
  static const String complianceReminders = 'compliance_reminders';
  static const String parsedCvRecords = 'parsed_cv_records';
}
