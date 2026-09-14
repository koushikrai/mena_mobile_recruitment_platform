import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mena_recruitment/core/network/api_client.dart';
import 'package:mena_recruitment/core/network/api_endpoints.dart';
import 'package:mena_recruitment/features/profile/domain/profile_repository.dart';
import 'package:mena_recruitment/features/profile/domain/candidate_profile_entity.dart';
import 'package:mena_recruitment/features/profile/domain/relocation_preferences.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient _apiClient = ApiClient();

  CandidateProfile _profile = CandidateProfile.empty;

  @override
  Future<CandidateProfile> getProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.candidateMe);
      if (response.statusCode == 200 && response.data != null) {
        _profile = CandidateProfile.fromJson(response.data as Map<String, dynamic>);
        return _profile;
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        debugPrint('[ProfileRepo] Guest session active, using profile');
      } else {
        debugPrint('[ProfileRepo] Backend getProfile error, falling back: $e');
      }
    }

    await Future.delayed(const Duration(milliseconds: 200));
    return _profile;
  }

  @override
  Future<void> updateProfile(CandidateProfile profile) async {
    _profile = profile;
    try {
      await _apiClient.put(
        ApiEndpoints.candidateProfile,
        data: profile.toJson(),
      );
    } catch (e) {
      debugPrint('[ProfileRepo] Backend updateProfile error, kept locally: $e');
    }
  }

  @override
  Future<void> updatePreferences(RelocationPreferences preferences) async {
    _profile = _profile.copyWith(
      preferredCountries: preferences.preferredCountries,
      expectedSalary: preferences.expectedSalary,
      expectedCurrency: preferences.currency,
      noticePeriod: preferences.noticePeriod,
    );

    try {
      await _apiClient.put(
        ApiEndpoints.candidateProfile,
        data: {
          'expected_salary_min': preferences.expectedSalary,
          'expected_salary_currency': preferences.currency,
          'notice_period_days': int.tryParse(preferences.noticePeriod.replaceAll(RegExp(r'\D'), '')) ?? 30,
        },
      );
    } catch (e) {
      debugPrint('[ProfileRepo] Preferences sync offline: $e');
    }
  }

  @override
  Future<void> deleteAccount() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
