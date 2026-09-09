import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';
import 'package:mena_recruitment/features/jobs/domain/job_filter.dart';
import 'package:mena_recruitment/features/jobs/domain/jobs_repository.dart';
import 'package:mena_recruitment/features/jobs/data/mock_jobs_data.dart';

class JobsRepositoryImpl implements JobsRepository {
  final Set<String> _bookmarkedIds = {};

  @override
  Future<List<Job>> getJobs({JobFilter? filter, int page = 1, int pageSize = 20}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    var filtered = MockJobsData.jobs;
    
    if (filter != null) {
      if (filter.searchQuery != null && filter.searchQuery!.trim().isNotEmpty) {
        final query = filter.searchQuery!.toLowerCase().trim();
        filtered = filtered.where((job) {
          final inTitle = job.title.toLowerCase().contains(query);
          final inCompany = job.companyName.toLowerCase().contains(query);
          final inDept = job.department.toLowerCase().contains(query);
          final inCity = job.city.toLowerCase().contains(query);
          final inSkills = job.requiredSkills.any((s) => s.toLowerCase().contains(query));
          return inTitle || inCompany || inDept || inCity || inSkills;
        }).toList();
      }
      
      if (filter.selectedCountries.isNotEmpty) {
        final countryAliases = <String>{};
        for (final c in filter.selectedCountries) {
          final lower = c.toLowerCase();
          countryAliases.add(lower);
          if (lower == 'ksa' || lower == 'sau' || lower == 'saudi arabia') {
            countryAliases.addAll(['ksa', 'sau']);
          } else if (lower == 'uae' || lower == 'united arab emirates') {
            countryAliases.addAll(['uae', 'are']);
          } else if (lower == 'qatar' || lower == 'qat') {
            countryAliases.addAll(['qatar', 'qat']);
          } else if (lower == 'kuwait' || lower == 'kwt') {
            countryAliases.addAll(['kuwait', 'kwt']);
          } else if (lower == 'oman' || lower == 'omn') {
            countryAliases.addAll(['oman', 'omn']);
          } else if (lower == 'bahrain' || lower == 'bhr') {
            countryAliases.addAll(['bahrain', 'bhr']);
          }
        }
        filtered = filtered.where((job) => 
          countryAliases.contains(job.countryCode.toLowerCase())
        ).toList();
      }

      if (filter.visaSponsored == true) {
        filtered = filtered.where((job) => 
          job.visaStatus.toLowerCase().contains('sponsored') ||
          job.visaStatus.toLowerCase().contains('provided') ||
          job.relocationBenefits.any((b) => b.toLowerCase().contains('visa'))
        ).toList();
      }

      if (filter.transferableIqama == true) {
        filtered = filtered.where((job) => 
          job.visaStatus.toLowerCase().contains('iqama') || job.iqamaTransferable
        ).toList();
      }

      if (filter.housingIncluded == true) {
        filtered = filtered.where((job) => 
          job.accommodation.toLowerCase().contains('provided') || 
          job.accommodation.toLowerCase().contains('allowance') ||
          job.accommodation.toLowerCase().contains('camp') ||
          job.accommodation.toLowerCase().contains('suite')
        ).toList();
      }
    }

    return filtered.map((job) => job.copyWith(isBookmarked: _bookmarkedIds.contains(job.id))).toList();
  }

  @override
  Future<Job> getJobById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final job = MockJobsData.jobs.firstWhere((j) => j.id == id);
    return job.copyWith(isBookmarked: _bookmarkedIds.contains(job.id));
  }

  @override
  Future<void> toggleBookmark(String jobId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_bookmarkedIds.contains(jobId)) {
      _bookmarkedIds.remove(jobId);
    } else {
      _bookmarkedIds.add(jobId);
    }
  }

  @override
  Future<List<Job>> getBookmarkedJobs() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockJobsData.jobs
      .where((job) => _bookmarkedIds.contains(job.id))
      .map((job) => job.copyWith(isBookmarked: true))
      .toList();
  }
}
