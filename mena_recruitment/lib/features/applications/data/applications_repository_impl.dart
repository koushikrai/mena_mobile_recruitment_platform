import 'package:flutter/foundation.dart';
import 'package:mena_recruitment/core/network/api_client.dart';
import 'package:mena_recruitment/core/network/api_endpoints.dart';
import '../domain/application_entity.dart';
import '../domain/applications_repository.dart';
import 'mock_applications_data.dart';

class ApplicationsRepositoryImpl implements ApplicationsRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<List<JobApplication>> getApplications() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.applications);
      if (response.statusCode == 200 && response.data is List) {
        final rawList = response.data as List;
        if (rawList.isNotEmpty) {
          return rawList
              .map((json) => JobApplication.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('[ApplicationsRepo] Backend error, falling back to mock: $e');
    }

    await Future.delayed(const Duration(milliseconds: 300));
    return mockApplications;
  }

  @override
  Future<JobApplication?> getApplicationById(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.applicationById(id));
      if (response.statusCode == 200 && response.data != null) {
        return JobApplication.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('[ApplicationsRepo] Backend error for getApplicationById($id): $e');
    }

    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return mockApplications.firstWhere((app) => app.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<JobApplication>> filterByStage(RelocationStage stage) async {
    final all = await getApplications();
    return all.where((app) => app.currentStage == stage).toList();
  }

  @override
  Future<JobApplication> applyForJob({
    required String jobId,
    String? coverNote,
    List<String>? documentIds,
  }) async {
    try {
      final payload = <String, dynamic>{'job_id': jobId};
      if (coverNote != null) payload['cover_note'] = coverNote;
      if (documentIds != null) payload['document_ids'] = documentIds;

      final response = await _apiClient.post(
        ApiEndpoints.applications,
        data: payload,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return JobApplication.fromJson(response.data as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint('[ApplicationsRepo] Backend apply error, creating local item: $e');
    }

    final newApp = JobApplication(
      id: 'app-${DateTime.now().millisecondsSinceEpoch}',
      jobId: jobId,
      jobTitle: 'Verified Position',
      companyName: 'GCC Verified Employer',
      companyLogoUrl: 'https://images.unsplash.com/photo-1541888946425-d0fbb1861593?w=128',
      countryCode: 'sau',
      city: 'Riyadh',
      appliedDate: DateTime.now(),
      currentStage: RelocationStage.applied,
      statusLabel: 'Stage 1/6: Applied & Verification Underway',
      severity: StatusSeverity.info,
    );
    mockApplications.insert(0, newApp);
    return newApp;
  }

  @override
  Future<bool> updateApplicationStage(String applicationId, RelocationStage newStage) async {
    try {
      final response = await _apiClient.patch(
        '${ApiEndpoints.applications}/$applicationId/status',
        data: {'status': newStage.name},
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint('[ApplicationsRepo] Backend update stage fallback: $e');
    }

    final idx = mockApplications.indexWhere((app) => app.id == applicationId);
    if (idx != -1) {
      final existing = mockApplications[idx];
      mockApplications[idx] = existing.copyWith(
        currentStage: newStage,
        statusLabel: 'Stage ${newStage.index + 1}/6: ${newStage.name}',
      );
      return true;
    }
    return true;
  }
}
