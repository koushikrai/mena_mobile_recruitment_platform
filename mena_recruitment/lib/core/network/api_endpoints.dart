/// Centralized API endpoint routes matching the FastAPI backend.
class ApiEndpoints {
  ApiEndpoints._();

  // Authentication
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String me = '/auth/me';

  // Candidate Profile & Readiness
  static const String candidateMe = '/candidates/me';
  static const String candidateProfile = '/candidates/profile';
  static const String candidateReadiness = '/candidates/readiness';
  static const String candidateExperiences = '/candidates/experiences';
  static const String candidateEducations = '/candidates/educations';
  static const String candidateSkills = '/candidates/skills';

  // Jobs & Walk-in Drives
  static const String jobs = '/jobs';
  static String jobById(String id) => '/jobs/$id';
  static String jobBookmark(String id) => '/jobs/$id/bookmark';
  static const String walkinDrives = '/jobs/walkin-drives/all';
  static String walkinRegister(String driveId) => '/jobs/walkin-drives/$driveId/register';

  // 6-Stage Relocation Pipeline & Applications
  static const String applications = '/applications';
  static String applicationById(String id) => '/applications/$id';
  static String applicationStage(String id) => '/applications/$id/stage';

  // Document Vault & AI Services
  static const String vaultDocuments = '/vault/documents';
  static const String vaultUpload = '/vault/upload';
  static const String mrzVerify = '/vault/mrz/verify';
  static const String cvParse = '/vault/cv/parse';

  // Compliance & Expiration Checks
  static const String complianceReminders = '/compliance/reminders';
  static const String complianceCheckExpiry = '/compliance/check-expiry';
}
