import 'package:flutter_test/flutter_test.dart';
import 'package:mena_recruitment/features/jobs/data/mock_jobs_data.dart';
import 'package:mena_recruitment/features/jobs/data/jobs_repository_impl.dart';
import 'package:mena_recruitment/features/jobs/domain/job_filter.dart';
import 'package:mena_recruitment/features/jobs/domain/recruitment_region.dart';

void main() {
  group('Region Switching & Job Visibility Verification', () {
    final repo = JobsRepositoryImpl();

    test('Total mock catalog contains at least 30 jobs across all regions', () {
      expect(MockJobsData.jobs.length, greaterThanOrEqualTo(30));
    });

    test('Each region has a dedicated, rich set of vacancies with none left out', () async {
      for (final region in RecruitmentRegion.values) {
        final filter = JobFilter(region: region.id == 'global' ? null : region.id);
        final jobs = await repo.getJobs(filter: filter);

        if (region == RecruitmentRegion.global) {
          // Global should include every single job in the system
          expect(jobs.length, greaterThanOrEqualTo(MockJobsData.jobs.length),
              reason: 'Global must show all jobs without any left out');
        } else {
          // Every specific region should have at least 5 jobs
          expect(jobs.length, greaterThanOrEqualTo(5),
              reason: 'Region  should display all vacancies without being left out');
          // Verify that every returned job actually matches the region
          for (final j in jobs) {
            expect(region.matchesJob(j.region, j.countryCode), isTrue,
                reason: 'Job  (, ) should match region ');
          }
        }
      }
    });

    test('Region matching handles both region ID and country code aliases accurately', () {
      expect(RecruitmentRegion.gcc.matchesJob('gcc', 'sau'), isTrue);
      expect(RecruitmentRegion.gcc.matchesJob('gcc', 'uae'), isTrue);
      expect(RecruitmentRegion.apac.matchesJob('apac', 'sgp'), isTrue);
      expect(RecruitmentRegion.apac.matchesJob('apac', 'mys'), isTrue);
      expect(RecruitmentRegion.apac.matchesJob('apac', 'ind'), isTrue);
      expect(RecruitmentRegion.emea.matchesJob('emea', 'gbr'), isTrue);
      expect(RecruitmentRegion.emea.matchesJob('emea', 'deu'), isTrue);
      expect(RecruitmentRegion.usa.matchesJob('usa', 'can'), isTrue);
      expect(RecruitmentRegion.oceania.matchesJob('oceania', 'aus'), isTrue);
      expect(RecruitmentRegion.oceania.matchesJob('oceania', 'nzl'), isTrue);
      expect(RecruitmentRegion.global.matchesJob('any', 'any'), isTrue);
    });
  });
}
