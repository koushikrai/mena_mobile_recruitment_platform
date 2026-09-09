import 'package:flutter/foundation.dart';
import 'package:mena_recruitment/core/network/api_client.dart';
import 'package:mena_recruitment/core/network/api_endpoints.dart';
import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';
import 'package:mena_recruitment/features/jobs/domain/job_filter.dart';
import 'package:mena_recruitment/features/jobs/domain/jobs_repository.dart';
import 'package:mena_recruitment/features/jobs/data/mock_jobs_data.dart';

class JobsRepositoryImpl implements JobsRepository {
  final ApiClient _apiClient = ApiClient();
  final Set<String> _bookmarkedIds = {};

  @override
  Future<List<Job>> getJobs({JobFilter? filter, int page = 1, int pageSize = 20}) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
      };

      if (filter != null) {
        if (filter.searchQuery != null && filter.searchQuery!.trim().isNotEmpty) {
          queryParams['search_query'] = filter.searchQuery!.trim();
        }
        if (filter.selectedCountries.isNotEmpty) {
          queryParams['countries'] = filter.selectedCountries;
        }
        if (filter.visaSponsored == true) {
          queryParams['visa_sponsored'] = true;
        }
      }

      final response = await _apiClient.get(
        ApiEndpoints.jobs,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data is List) {
        final rawList = response.data as List;
        if (rawList.isNotEmpty) {
          final jobs = rawList
              .map((json) => Job.fromJson(json as Map<String, dynamic>))
              .map((job) => job.copyWith(
                    isBookmarked: _bookmarkedIds.contains(job.id) || job.isBookmarked,
                  ))
              .toList();
          return jobs;
        }
      }
    } catch (e) {
      debugPrint('[JobsRepo] Backend unreachable, falling back to mock jobs: $e');
    }

    // Graceful fallback to mock data
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
        filtered = filtered.where((job) => countryAliases.contains(job.countryCode.toLowerCase())).toList();
      }

      if (filter.visaSponsored == true) {
        filtered = filtered.where((job) =>
            job.visaStatus.toLowerCase().contains('sponsored') ||
            job.visaStatus.toLowerCase().contains('provided') ||
            job.relocationBenefits.any((b) => b.toLowerCase().contains('visa'))).toList();
      }

      if (filter.transferableIqama == true) {
        filtered = filtered.where((job) => job.visaStatus.toLowerCase().contains('iqama') || job.iqamaTransferable).toList();
      }

      if (filter.housingIncluded == true) {
        filtered = filtered.where((job) =>
            job.accommodation.toLowerCase().contains('provided') ||
            job.accommodation.toLowerCase().contains('allowance') ||
            job.accommodation.toLowerCase().contains('camp') ||
            job.accommodation.toLowerCase().contains('suite')).toList();
      }
    }

    return filtered.map((job) => job.copyWith(isBookmarked: _bookmarkedIds.contains(job.id))).toList();
  }

  @override
  Future<Job> getJobById(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.jobById(id));
      if (response.statusCode == 200 && response.data != null) {
        final job = Job.fromJson(response.data as Map<String, dynamic>);
        return job.copyWith(isBookmarked: _bookmarkedIds.contains(job.id) || job.isBookmarked);
      }
    } catch (e) {
      debugPrint('[JobsRepo] Backend error for getJobById($id), falling back to mock: $e');
    }

    await Future.delayed(const Duration(milliseconds: 150));
    final job = MockJobsData.jobs.firstWhere(
      (j) => j.id == id,
      orElse: () => MockJobsData.jobs.first,
    );
    return job.copyWith(isBookmarked: _bookmarkedIds.contains(job.id));
  }

  @override
  Future<void> toggleBookmark(String jobId) async {
    if (_bookmarkedIds.contains(jobId)) {
      _bookmarkedIds.remove(jobId);
    } else {
      _bookmarkedIds.add(jobId);
    }

    try {
      await _apiClient.post(ApiEndpoints.jobBookmark(jobId));
    } catch (e) {
      debugPrint('[JobsRepo] Bookmark sync offline: $e');
    }
  }

  @override
  Future<List<Job>> getBookmarkedJobs() async {
    final all = await getJobs();
    return all.where((job) => _bookmarkedIds.contains(job.id) || job.isBookmarked).toList();
  }
}
