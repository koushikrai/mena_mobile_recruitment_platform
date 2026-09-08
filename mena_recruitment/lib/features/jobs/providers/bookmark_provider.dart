import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/jobs/providers/jobs_provider.dart';

class BookmarkNotifier extends StateNotifier<Set<String>> {
  final Ref ref;

  BookmarkNotifier(this.ref) : super({});

  Future<void> toggleBookmark(String jobId) async {
    final repo = ref.read(jobsRepositoryProvider);
    await repo.toggleBookmark(jobId);
    
    final current = Set<String>.from(state);
    if (current.contains(jobId)) {
      current.remove(jobId);
    } else {
      current.add(jobId);
    }
    state = current;

    // Refresh jobs list to update UI
    ref.invalidate(jobsProvider);
    ref.invalidate(filteredJobsProvider);
  }
}

final bookmarkProvider = StateNotifierProvider<BookmarkNotifier, Set<String>>((ref) {
  return BookmarkNotifier(ref);
});
