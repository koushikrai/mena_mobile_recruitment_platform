import 'package:mena_recruitment/features/profile/domain/candidate_profile_entity.dart';
import 'package:mena_recruitment/features/profile/domain/relocation_preferences.dart';

abstract class ProfileRepository {
  Future<CandidateProfile> getProfile();
  Future<void> updateProfile(CandidateProfile profile);
  Future<void> updatePreferences(RelocationPreferences preferences);
  Future<void> deleteAccount();
}
