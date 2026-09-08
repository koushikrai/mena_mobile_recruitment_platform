import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';
import 'package:mena_recruitment/features/jobs/domain/job_filter.dart';

abstract class JobsRepository {
  Future<List<Job>> getJobs({JobFilter? filter, int page = 1, int pageSize = 20});
  Future<Job> getJobById(String id);
  Future<void> toggleBookmark(String jobId);
  Future<List<Job>> getBookmarkedJobs();
}
