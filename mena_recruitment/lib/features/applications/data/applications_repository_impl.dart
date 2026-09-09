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
}
