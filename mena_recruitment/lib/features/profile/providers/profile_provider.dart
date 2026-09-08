import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mena_recruitment/features/profile/domain/candidate_profile_entity.dart';
import 'package:mena_recruitment/features/profile/data/profile_repository_impl.dart';

part 'profile_provider.g.dart';

final profileRepositoryProvider = Provider((ref) => ProfileRepositoryImpl());

@riverpod
class Profile extends _$Profile {
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
