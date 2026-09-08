import 'package:mena_recruitment/features/profile/domain/profile_repository.dart';
import 'package:mena_recruitment/features/profile/domain/candidate_profile_entity.dart';
import 'package:mena_recruitment/features/profile/domain/relocation_preferences.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  CandidateProfile _profile = const CandidateProfile(
    id: 'user-001',
    uid: 'UID-99482',
    fullName: 'Rahul Sharma',
    email: 'rahul.sharma@example.com',
    phone: '+91 9876543210',
    nationality: 'Indian',
    residentCountry: 'India',
    targetTitle: 'Senior Mechanical Engineer',
    totalExperience: 8,
    gccExperience: 0,
    readinessScore: 85,
    isActivelyLooking: true,
    preferredCountries: ['Saudi Arabia', 'UAE', 'Qatar'],
    expectedSalary: 8000.0,
    expectedCurrency: 'SAR',
    noticePeriod: '30 Days',
    relocationStatus: 'Ready to relocate',
    isGccVerified: true,
  );

  @override
  Future<CandidateProfile> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _profile;
  }

  @override
  Future<void> updateProfile(CandidateProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _profile = profile;
  }

  @override
  Future<void> updatePreferences(RelocationPreferences preferences) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _profile = _profile.copyWith(
      preferredCountries: preferences.preferredCountries,
      expectedSalary: preferences.expectedSalary,
      expectedCurrency: preferences.currency,
      noticePeriod: preferences.noticePeriod,
    );
  }

  @override
  Future<void> deleteAccount() async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }
}
