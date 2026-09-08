import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/profile/domain/candidate_profile_entity.dart';
import 'package:mena_recruitment/features/profile/data/profile_repository_impl.dart';

final profileRepositoryProvider = Provider((ref) => ProfileRepositoryImpl());

final profileProvider = AsyncNotifierProvider<ProfileNotifier, CandidateProfile>(() {
  return ProfileNotifier();
});

class ProfileNotifier extends AsyncNotifier<CandidateProfile> {
  @override
  Future<CandidateProfile> build() async {
    return ref.watch(profileRepositoryProvider).getProfile();
  }

  Future<void> updateAvailability(bool isLooking) async {
    final current = state.value;
    if (current != null) {
      final updated = current.copyWith(isActivelyLooking: isLooking);
      state = AsyncValue.data(updated);
      await ref.read(profileRepositoryProvider).updateProfile(updated);
    }
  }
}
