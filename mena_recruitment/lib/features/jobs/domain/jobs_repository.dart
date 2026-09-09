import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';
import 'package:mena_recruitment/features/jobs/domain/job_filter.dart';
import 'package:mena_recruitment/features/jobs/domain/walkin_drive_entity.dart';

abstract class JobsRepository {
  Future<List<Job>> getJobs({JobFilter? filter, int page = 1, int pageSize = 20});
  Future<Job> getJobById(String id);
  Future<void> toggleBookmark(String jobId);
  Future<List<Job>> getBookmarkedJobs();
  Future<List<WalkinDrive>> getWalkinDrives();
  Future<WalkinRegistration> registerForWalkinDrive(String driveId, String timeSlot);
}
