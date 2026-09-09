import 'package:flutter/foundation.dart';
import 'package:mena_recruitment/core/network/api_client.dart';
import 'package:mena_recruitment/core/network/api_endpoints.dart';
import 'package:mena_recruitment/features/profile/domain/profile_repository.dart';
import 'package:mena_recruitment/features/profile/domain/candidate_profile_entity.dart';
import 'package:mena_recruitment/features/profile/domain/relocation_preferences.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient _apiClient = ApiClient();

  CandidateProfile _profile = const CandidateProfile(
    id: 'user-001',
    uid: 'UID-99482',
    fullName: 'Ahmed Mansoor Al-Sayed',
    email: 'candidate@suhana-global.com',
    phone: '+966 550123456',
    nationality: 'Egyptian',
    residentCountry: 'Egypt',
    targetTitle: 'Senior Offshore HSE Supervisor',
    totalExperience: 7,
    gccExperience: 4,
    readinessScore: 85,
    isActivelyLooking: true,
    preferredCountries: ['Saudi Arabia', 'UAE', 'Qatar'],
    expectedSalary: 14000.0,
    expectedCurrency: 'SAR',
    noticePeriod: '30 Days',
    relocationStatus: 'Ready for Relocation',
    isGccVerified: true,
  );

  @override
  Future<CandidateProfile> getProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.candidateMe);
      if (response.statusCode == 200 && response.data != null) {
        _profile = CandidateProfile.fromJson(response.data as Map<String, dynamic>);
        return _profile;
      }
    } catch (e) {
      debugPrint('[ProfileRepo] Backend getProfile error, falling back: $e');
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
