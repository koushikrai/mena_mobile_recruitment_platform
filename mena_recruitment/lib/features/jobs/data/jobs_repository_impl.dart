import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';
import 'package:mena_recruitment/features/jobs/domain/job_filter.dart';
import 'package:mena_recruitment/features/jobs/domain/jobs_repository.dart';
import 'package:mena_recruitment/features/jobs/data/mock_jobs_data.dart';

class JobsRepositoryImpl implements JobsRepository {
  final Set<String> _bookmarkedIds = {};

  @override
  Future<List<Job>> getJobs({JobFilter? filter, int page = 1, int pageSize = 20}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    var filtered = mockJobsData;
    
    if (filter != null) {
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        final query = filter.searchQuery!.toLowerCase();
        filtered = filtered.where((job) => 
          job.title.toLowerCase().contains(query) || 
          job.companyName.toLowerCase().contains(query)
        ).toList();
      }
      
      if (filter.selectedCountries.isNotEmpty) {
        filtered = filtered.where((job) => 
          filter.selectedCountries.contains(job.countryCode)
        ).toList();
      }

      if (filter.visaSponsored == true) {
        filtered = filtered.where((job) => 
          job.visaStatus == 'Fully Sponsored'
        ).toList();
      }

      if (filter.transferableIqama == true) {
        filtered = filtered.where((job) => 
          job.visaStatus == 'Transferable Iqama' || job.iqamaTransferable
        ).toList();
      }

      if (filter.housingIncluded == true) {
        filtered = filtered.where((job) => 
          job.accommodation == 'Provided' || job.accommodation == 'Housing Allowance'
        ).toList();
      }
    }

    return filtered.map((job) => job.copyWith(isBookmarked: _bookmarkedIds.contains(job.id))).toList();
  }

  @override
  Future<Job> getJobById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final job = mockJobsData.firstWhere((j) => j.id == id);
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
    return mockJobsData
      .where((job) => _bookmarkedIds.contains(job.id))
      .map((job) => job.copyWith(isBookmarked: true))
      .toList();
  }
}
