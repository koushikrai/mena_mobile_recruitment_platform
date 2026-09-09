import 'package:flutter_test/flutter_test.dart';
import 'package:mena_recruitment/core/network/api_client.dart';
import 'package:mena_recruitment/core/network/api_endpoints.dart';
import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';
import 'package:mena_recruitment/features/jobs/data/jobs_repository_impl.dart';
import 'package:mena_recruitment/features/applications/domain/application_entity.dart';
import 'package:mena_recruitment/features/applications/data/applications_repository_impl.dart';
import 'package:mena_recruitment/features/profile/domain/candidate_profile_entity.dart';
import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';

void main() {
  group('Frontend-Backend Network Integration & Mappers', () {
    test('ApiEndpoints are properly structured', () {
      expect(ApiEndpoints.jobs, '/jobs');
      expect(ApiEndpoints.applications, '/applications');
      expect(ApiEndpoints.cvParse, '/vault/cv/parse');
      expect(ApiEndpoints.mrzVerify, '/vault/mrz/verify');
      expect(ApiEndpoints.candidateMe, '/candidates/me');
      expect(ApiEndpoints.walkinDrives, '/jobs/walkin-drives/all');
    });

    test('ApiClient initializes with platform base URL and timeout', () {
      final client = ApiClient();
      expect(client.dio.options.baseUrl, isNotEmpty);
      expect(client.dio.options.connectTimeout, const Duration(seconds: 15));
    });

    test('Job.fromJson correctly maps FastAPI JobResponse JSON', () {
      final backendJson = {
        'id': 'job-999',
        'company_id': 'comp-111',
        'company_name': 'PetroGulf Energy Ltd.',
        'company_logo': 'https://example.com/logo.png',
        'reference_code': 'PG-HSE-908',
        'title': 'Senior Offshore HSE Supervisor',
        'sector': 'Oil & Gas',
        'country_code': 'KSA',
        'city': 'Dammam',
        'salary_min': 14000.0,
        'salary_max': 18000.0,
        'salary_currency': 'SAR',
        'visa_status': 'Free Visa & Work Permit Provided',
        'required_skills': ['NEBOSH IGC', 'BOSIET'],
        'description': 'Zero incident safety management offshore.',
        'zero_recruitment_fee_guarantee': true,
        'is_urgent': true,
        'is_bookmarked': true,
      };

      final job = Job.fromJson(backendJson);
      expect(job.id, 'job-999');
      expect(job.title, 'Senior Offshore HSE Supervisor');
      expect(job.companyName, 'PetroGulf Energy Ltd.');
      expect(job.department, 'Oil & Gas');
      expect(job.countryCode, 'ksa');
      expect(job.currency, 'SAR');
      expect(job.salaryMin, 14000.0);
      expect(job.salaryMax, 18000.0);
      expect(job.isBookmarked, isTrue);
      expect(job.requiredSkills, contains('NEBOSH IGC'));
    });

    test('JobApplication.fromJson maps 6-stage pipeline from backend status', () {
      final appJson = {
        'id': 'app-100',
        'job_id': 'job-999',
        'job_title': 'Senior Offshore HSE Supervisor',
        'company_name': 'PetroGulf Energy Ltd.',
        'country_code': 'KSA',
        'status': 'screening',
        'applied_at': '2026-09-09T08:25:30Z',
      };

      final app = JobApplication.fromJson(appJson);
      expect(app.id, 'app-100');
      expect(app.currentStage, RelocationStage.screening);
      expect(app.jobTitle, 'Senior Offshore HSE Supervisor');
      expect(app.companyName, 'PetroGulf Energy Ltd.');
    });

    test('CandidateProfile.fromJson maps backend profile data', () {
      final profileJson = {
        'id': 'prof-1',
        'full_name': 'Ahmed Mansoor Al-Sayed',
        'target_job_title': 'Lead HSE Specialist',
        'nationality': 'Egyptian',
        'current_resident_country': 'Egypt',
        'total_experience_years': 8.0,
        'gcc_experience_years': 4.0,
        'relocation_readiness_score': 85,
        'is_actively_looking': true,
        'expected_salary_min': 15000.0,
        'expected_salary_currency': 'SAR',
      };

      final profile = CandidateProfile.fromJson(profileJson);
      expect(profile.fullName, 'Ahmed Mansoor Al-Sayed');
      expect(profile.targetTitle, 'Lead HSE Specialist');
      expect(profile.readinessScore, 85);
      expect(profile.totalExperience, 8);
      expect(profile.expectedCurrency, 'SAR');
    });

    test('VaultDocument.fromJson maps ICAO passport verification status', () {
      final vaultJson = {
        'id': 'doc-1',
        'document_type': 'passport',
        'file_name': 'Ahmed_Passport.pdf',
        'passport_number': 'N8492014',
        'issuing_country': 'EGY',
        'expiry_date': '2029-03-09',
        'has_six_months_validity': true,
        'is_verified': true,
      };

      final doc = VaultDocument.fromJson(vaultJson);
      expect(doc.id, 'doc-1');
      expect(doc.category, DocumentCategory.passport);
      expect(doc.documentNumber, 'N8492014');
      expect(doc.isValidForGccVisa, isTrue);
      expect(doc.isVerified, isTrue);
    });

    test('JobsRepositoryImpl and ApplicationsRepositoryImpl fallback seamlessly', () async {
      final jobsRepo = JobsRepositoryImpl();
      final jobs = await jobsRepo.getJobs();
      expect(jobs, isNotEmpty);
      expect(jobs.first.title, isNotEmpty);

      final appsRepo = ApplicationsRepositoryImpl();
      final apps = await appsRepo.getApplications();
      expect(apps, isNotEmpty);
      expect(apps.first.jobTitle, isNotEmpty);
    });
  });
}
