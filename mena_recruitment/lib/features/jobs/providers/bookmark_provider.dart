import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';
import 'package:mena_recruitment/features/jobs/providers/jobs_provider.dart';

class BookmarkNotifier extends StateNotifier<Set<String>> {
  final Ref ref;
  static const String _storageKey = 'mena_bookmarked_jobs_ids';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  BookmarkNotifier(this.ref) : super({}) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      final raw = await _storage.read(key: _storageKey);
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
        final ids = decoded.map((e) => e.toString()).toSet();
        if (ids.isNotEmpty) {
          state = ids;
        }
      }
    } catch (_) {}
  }

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

    try {
      await _storage.write(key: _storageKey, value: jsonEncode(state.toList()));
    } catch (_) {}

    // Refresh jobs list to update UI
    ref.invalidate(jobsProvider);
    ref.invalidate(filteredJobsProvider);
  }

  Future<void> removeBookmark(String jobId) async {
    if (!state.contains(jobId)) return;
    await toggleBookmark(jobId);
  }

  Future<void> addBookmark(String jobId) async {
    if (state.contains(jobId)) return;
    await toggleBookmark(jobId);
  }
}

final bookmarkProvider = StateNotifierProvider<BookmarkNotifier, Set<String>>((ref) {
  return BookmarkNotifier(ref);
});

final savedJobsProvider = FutureProvider<List<Job>>((ref) async {
  final bookmarkedIds = ref.watch(bookmarkProvider);
  if (bookmarkedIds.isEmpty) return <Job>[];

  final repo = ref.read(jobsRepositoryProvider);
  final allJobs = await repo.getJobs();
  return allJobs.where((job) => bookmarkedIds.contains(job.id)).toList();
});

