import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';
import 'package:mena_recruitment/features/jobs/providers/jobs_provider.dart';

final jobDetailsProvider = FutureProvider.family<Job, String>((ref, id) async {
  final repo = ref.watch(jobsRepositoryProvider);
  return await repo.getJobById(id);
});
