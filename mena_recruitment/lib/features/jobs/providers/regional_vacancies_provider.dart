import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';
import 'package:mena_recruitment/features/jobs/domain/job_filter.dart';
import 'package:mena_recruitment/features/jobs/domain/recruitment_region.dart';
import 'package:mena_recruitment/features/jobs/providers/jobs_provider.dart';
import 'package:mena_recruitment/features/jobs/providers/region_provider.dart';

/// Real-time statistics of vacancies across a region fetched from existing jobs in the database.
class RegionalVacanciesStats {
  final int totalVacancies;
  final int highPriorityVacancies;
  final List<String> countries;
  final String countriesSummary;
  final double minSalary;
  final double maxSalary;
  final String currency;
  final String formattedSalaryRange;
  final bool isTaxFree;
  final String regionLabel;
  final bool isHighDemand;

  const RegionalVacanciesStats({
    required this.totalVacancies,
    required this.highPriorityVacancies,
    required this.countries,
    required this.countriesSummary,
    required this.minSalary,
    required this.maxSalary,
    required this.currency,
    required this.formattedSalaryRange,
    required this.isTaxFree,
    required this.regionLabel,
    this.isHighDemand = true,
  });

  factory RegionalVacanciesStats.empty(String regionLabel) {
    return RegionalVacanciesStats(
      totalVacancies: 0,
      highPriorityVacancies: 0,
      countries: const [],
      countriesSummary: regionLabel,
      minSalary: 0,
      maxSalary: 0,
      currency: 'SAR',
      formattedSalaryRange: 'Market Competitive',
      isTaxFree: true,
      regionLabel: regionLabel,
      isHighDemand: false,
    );
  }
}

String mapUiRegionToId(String regionStr) {
  final lower = regionStr.toLowerCase().trim();
  if (lower.contains('gcc') || lower.contains('middle east')) return 'gcc';
  if (lower.contains('levant') || lower.contains('africa')) return 'gcc';
  if (lower.contains('apac') || lower.contains('asia')) return 'apac';
  if (lower.contains('emea') || lower.contains('europe')) return 'emea';
  if (lower.contains('usa') || lower.contains('north america') || lower.contains('america')) return 'usa';
  if (lower.contains('oceania') || lower.contains('australia') || lower.contains('pacific')) return 'oceania';
  if (lower.contains('global') || lower.contains('all')) return 'global';
  return RecruitmentRegion.fromId(regionStr).id;
}

String countryCodeToName(String code) {
  final lower = code.toLowerCase().trim();
  switch (lower) {
    case 'sau':
    case 'ksa':
    case 'saudi':
    case 'saudi arabia':
      return 'Saudi Arabia';
    case 'uae':
    case 'are':
    case 'dubai':
    case 'abu dhabi':
    case 'united arab emirates':
      return 'UAE';
    case 'qat':
    case 'qatar':
      return 'Qatar';
    case 'kwt':
    case 'kuwait':
      return 'Kuwait';
    case 'omn':
    case 'oman':
      return 'Oman';
    case 'bhr':
    case 'bahrain':
      return 'Bahrain';
    case 'sgp':
    case 'singapore':
      return 'Singapore';
    case 'mys':
    case 'malaysia':
      return 'Malaysia';
    case 'ind':
    case 'india':
      return 'India';
    case 'jpn':
    case 'japan':
      return 'Japan';
    case 'kor':
    case 'south korea':
    case 'korea':
      return 'South Korea';
    case 'gbr':
    case 'uk':
    case 'united kingdom':
      return 'United Kingdom';
    case 'deu':
    case 'germany':
      return 'Germany';
    case 'fra':
    case 'france':
      return 'France';
    case 'nld':
    case 'netherlands':
      return 'Netherlands';
    case 'usa':
    case 'us':
    case 'united states':
      return 'United States';
    case 'can':
    case 'canada':
      return 'Canada';
    case 'aus':
    case 'australia':
      return 'Australia';
    case 'nzl':
    case 'new zealand':
      return 'New Zealand';
    case 'png':
      return 'Papua New Guinea';
    case 'egy':
    case 'egypt':
      return 'Egypt';
    case 'jor':
    case 'jordan':
      return 'Jordan';
    case 'lbn':
    case 'lebanon':
      return 'Lebanon';
    case 'mar':
    case 'morocco':
      return 'Morocco';
    case 'zaf':
    case 'south africa':
      return 'South Africa';
    default:
      return code.toUpperCase();
  }
}

RegionalVacanciesStats computeRegionalVacanciesStats({
  required List<Job> jobs,
  required String regionLabel,
  List<String>? selectedCountries,
}) {
  var activeJobs = jobs;
  if (selectedCountries != null && selectedCountries.isNotEmpty) {
    final countryMatches = jobs.where((j) {
      final name = countryCodeToName(j.countryCode).toLowerCase();
      final code = j.countryCode.toLowerCase();
      return selectedCountries.any((c) =>
          c.toLowerCase() == name || c.toLowerCase() == code);
    }).toList();

    if (countryMatches.isNotEmpty) {
      activeJobs = countryMatches;
    }
  }

  if (activeJobs.isEmpty) {
    return RegionalVacanciesStats.empty(regionLabel);
  }

  // Count frequency of jobs per country
  final countryFrequency = <String, int>{};
  for (final job in activeJobs) {
    final name = countryCodeToName(job.countryCode);
    countryFrequency[name] = (countryFrequency[name] ?? 0) + 1;
  }

  // Sort countries by number of vacancies descending, then by name
  final countryList = countryFrequency.keys.toList()
    ..sort((a, b) {
      final cmp = countryFrequency[b]!.compareTo(countryFrequency[a]!);
      if (cmp != 0) return cmp;
      return a.compareTo(b);
    });

  String countriesSummary;
  if (countryList.isEmpty) {
    countriesSummary = regionLabel;
  } else if (countryList.length == 1) {
    countriesSummary = countryList.first;
  } else if (countryList.length == 2) {
    countriesSummary = '${countryList[0]} & ${countryList[1]}';
  } else {
    final top = countryList.take(3).toList();
    countriesSummary = '${top.sublist(0, top.length - 1).join(', ')} & ${top.last}';
  }

  // Salary range
  // Determine primary currency for the region based on frequency
  final currencyFrequency = <String, int>{};
  for (final job in activeJobs) {
    if (job.currency.isNotEmpty) {
      currencyFrequency[job.currency] = (currencyFrequency[job.currency] ?? 0) + 1;
    }
  }

  // Pick currency with highest count; for GCC specifically, prefer SAR as benchmark
  String primaryCurrency;
  if (currencyFrequency.isEmpty) {
    primaryCurrency = mapUiRegionToId(regionLabel) == 'gcc' ? 'SAR' : 'USD';
  } else if (mapUiRegionToId(regionLabel) == 'gcc' && currencyFrequency.containsKey('SAR')) {
    primaryCurrency = 'SAR';
  } else {
    final sortedCurrencies = currencyFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    primaryCurrency = sortedCurrencies.first.key;
  }

  final currencyJobs = activeJobs.where((j) => j.currency == primaryCurrency).toList();
  final targetJobsForSalary = currencyJobs.isNotEmpty ? currencyJobs : activeJobs;

  final validMinSalaries = targetJobsForSalary.map((j) => j.salaryMin).where((s) => s > 0).toList();
  final validMaxSalaries = targetJobsForSalary.map((j) => j.salaryMax).where((s) => s > 0).toList();

  final double minSal = validMinSalaries.isNotEmpty
      ? validMinSalaries.reduce((a, b) => a < b ? a : b)
      : 14000.0;
  final double maxSal = validMaxSalaries.isNotEmpty
      ? validMaxSalaries.reduce((a, b) => a > b ? a : b)
      : 18500.0;

  final formatter = NumberFormat('#,###');
  final formattedSalaryRange = '$primaryCurrency ${formatter.format(minSal.toInt())} – ${formatter.format(maxSal.toInt())}';

  final highPriority = activeJobs.where((j) => j.salaryMax >= 15000 || j.isTaxFree).length;

  return RegionalVacanciesStats(
    totalVacancies: activeJobs.length,
    highPriorityVacancies: highPriority > 0 ? highPriority : activeJobs.length,
    countries: countryList,
    countriesSummary: countriesSummary,
    minSalary: minSal,
    maxSalary: maxSal,
    currency: primaryCurrency,
    formattedSalaryRange: formattedSalaryRange,
    isTaxFree: activeJobs.any((j) => j.isTaxFree),
    regionLabel: regionLabel,
    isHighDemand: activeJobs.length >= 2,
  );
}

/// Fetches realtime regional vacancies directly from the database through jobs repository.
final regionalVacanciesStatsProvider =
    FutureProvider.family<RegionalVacanciesStats, String>((ref, regionName) async {
  final repo = ref.read(jobsRepositoryProvider);
  final regionId = mapUiRegionToId(regionName);
  final filter = JobFilter(region: regionId == 'global' ? null : regionId);
  final jobs = await repo.getJobs(filter: filter);
  return computeRegionalVacanciesStats(
    jobs: jobs,
    regionLabel: regionName,
  );
});

/// Fetches realtime vacancies matching the candidate's active selected platform region.
final activeRegionVacanciesStatsProvider = FutureProvider<RegionalVacanciesStats>((ref) async {
  final activeRegion = ref.watch(selectedRegionProvider);
  final repo = ref.read(jobsRepositoryProvider);
  final filter = JobFilter(region: activeRegion.id == 'global' ? null : activeRegion.id);
  final jobs = await repo.getJobs(filter: filter);
  return computeRegionalVacanciesStats(
    jobs: jobs,
    regionLabel: activeRegion.shortLabel,
  );
});
