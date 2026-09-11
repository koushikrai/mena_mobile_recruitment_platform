import 'package:flutter/foundation.dart';
import 'package:mena_recruitment/core/network/api_client.dart';
import 'package:mena_recruitment/core/network/api_endpoints.dart';
import '../domain/application_entity.dart';
import '../domain/applications_repository.dart';
import 'mock_applications_data.dart';

class ApplicationsRepositoryImpl implements ApplicationsRepository {
  final ApiClient _apiClient = ApiClient();
  static final List<JobApplication> _submittedApplications = [];

  @override
  Future<List<JobApplication>> getApplications() async {
    List<JobApplication> baseList = [];
    try {
      final response = await _apiClient.get(ApiEndpoints.applications);
      if (response.statusCode == 200 && response.data is List) {
        final rawList = response.data as List;
        if (rawList.isNotEmpty) {
          baseList = rawList
              .map((json) => JobApplication.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('[ApplicationsRepo] Backend error: $e');
    }

    if (baseList.isEmpty) {
      baseList = List<JobApplication>.from(mockApplications);
    }

    // Merge in newly submitted applications at the top
    final merged = <JobApplication>[
      ..._submittedApplications,
      ...baseList.where((b) => !_submittedApplications.any((s) => s.jobId == b.jobId || s.id == b.id)),
    ];

    await Future.delayed(const Duration(milliseconds: 100));
    return merged;
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

    await Future.delayed(const Duration(milliseconds: 100));
    try {
      final all = await getApplications();
      return all.firstWhere((app) => app.id == id);
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
    String? jobTitle,
    String? companyName,
    String? companyLogoUrl,
    String? countryCode,
    String? city,
    String? coverNote,
    List<String>? documentIds,
  }) async {
    JobApplication? backendApp;
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
          backendApp = JobApplication.fromJson(response.data as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint('[ApplicationsRepo] Local fallback for apply: $e');
    }

    final newApp = backendApp ??
        JobApplication(
          id: 'app-${DateTime.now().millisecondsSinceEpoch}',
          jobId: jobId,
          jobTitle: jobTitle ?? 'Offshore HSE Supervisor',
          companyName: companyName ?? 'PetroGulf Offshore Operations',
          companyLogoUrl: companyLogoUrl ??
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDs-2n5_Xkj2vrxXdOf2fHsOMdsLLjyHxlt2zdSglN6_hNoax51Oy7zvrFWVg5wE92lNPIzitVFTiVUp-oEzavNgACz4k3TFFQCNQNGgNlpPaCeDrr7_Mq0ocBcf18c-rrT9U_qaCpPNt2viUaUq0zWEODqB5wpAV-Ozpd16hE_BTt7YkEfTgsvzhqYmMv99HUKEt5rh4zAPN-01d4GOoIrMoexzML6K8mbSSd0tRvl3_GT5-xT166wmw',
          countryCode: (countryCode ?? 'SA').toUpperCase(),
          city: city ?? 'Yanbu',
          appliedDate: DateTime.now(),
          currentStage: RelocationStage.applied,
          statusLabel: 'Stage 1/6: Application Submitted & Verification Underway',
          severity: StatusSeverity.info,
        );

    _submittedApplications.removeWhere((a) => a.jobId == jobId);
    _submittedApplications.insert(0, newApp);
    mockApplications.removeWhere((a) => a.jobId == jobId);
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
