import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/jobs/domain/jobs_repository.dart';
import 'package:mena_recruitment/features/jobs/data/jobs_repository_impl.dart';
import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';
import 'package:mena_recruitment/features/jobs/providers/job_filter_provider.dart';

final jobsRepositoryProvider = Provider<JobsRepository>((ref) {
  return JobsRepositoryImpl();
});

class JobsNotifier extends AsyncNotifier<List<Job>> {
  @override
  Future<List<Job>> build() async {
    return _fetchJobs();
  }

  Future<List<Job>> _fetchJobs() async {
    final filter = ref.read(jobFilterProvider);
    final repo = ref.read(jobsRepositoryProvider);
    return await repo.getJobs(filter: filter);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchJobs());
  }
}

final jobsProvider = AsyncNotifierProvider<JobsNotifier, List<Job>>(() {
  return JobsNotifier();
});

final filteredJobsProvider = FutureProvider<List<Job>>((ref) async {
  final filter = ref.watch(jobFilterProvider);
  final repo = ref.read(jobsRepositoryProvider);
  return await repo.getJobs(filter: filter);
});
