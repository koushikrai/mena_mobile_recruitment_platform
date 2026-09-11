import 'package:flutter_test/flutter_test.dart';
import 'package:mena_recruitment/features/jobs/data/jobs_repository_impl.dart';
import 'package:mena_recruitment/features/jobs/domain/job_filter.dart';
import 'package:mena_recruitment/features/jobs/providers/regional_vacancies_provider.dart';

void main() {
  group('Real-time Regional Vacancies Provider & Stats Verification', () {
    final repo = JobsRepositoryImpl();

    test('GCC regional vacancies are fetched in realtime from database and not hardcoded', () async {
      final gccJobs = await repo.getJobs(filter: const JobFilter(region: 'gcc'));
      expect(gccJobs, isNotEmpty);

      final stats = computeRegionalVacanciesStats(
        jobs: gccJobs,
        regionLabel: 'GCC',
      );

      // Verify that the count is exactly equal to the existing jobs in the catalog/DB
      expect(stats.totalVacancies, equals(gccJobs.length));
      expect(stats.totalVacancies, isNot(equals(48))); // Ensures hardcoded 48 is gone
      expect(stats.countriesSummary, contains('Saudi Arabia'));
      expect(stats.formattedSalaryRange, startsWith('SAR'));
      expect(stats.isTaxFree, isTrue);
    });

    test('Vacancies stats for other regions dynamically adjust count, countries, and currency', () async {
      // APAC Region
      final apacJobs = await repo.getJobs(filter: const JobFilter(region: 'apac'));
      expect(apacJobs, isNotEmpty);
      final apacStats = computeRegionalVacanciesStats(
        jobs: apacJobs,
        regionLabel: 'APAC',
      );
      expect(apacStats.totalVacancies, equals(apacJobs.length));
      expect(apacStats.regionLabel, equals('APAC'));

      // EMEA Region
      final emeaJobs = await repo.getJobs(filter: const JobFilter(region: 'emea'));
      expect(emeaJobs, isNotEmpty);
      final emeaStats = computeRegionalVacanciesStats(
        jobs: emeaJobs,
        regionLabel: 'Europe',
      );
      expect(emeaStats.totalVacancies, equals(emeaJobs.length));
    });

    test('mapUiRegionToId maps UI region labels to repository region identifiers', () {
      expect(mapUiRegionToId('GCC'), equals('gcc'));
      expect(mapUiRegionToId('Europe'), equals('emea'));
      expect(mapUiRegionToId('North America'), equals('usa'));
      expect(mapUiRegionToId('Australia & Pacific'), equals('oceania'));
      expect(mapUiRegionToId('South & SE Asia'), equals('apac'));
    });
  });
}
