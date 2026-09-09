import 'application_entity.dart';

abstract class ApplicationsRepository {
  Future<List<JobApplication>> getApplications();
  Future<JobApplication?> getApplicationById(String id);
  Future<List<JobApplication>> filterByStage(RelocationStage stage);
  Future<JobApplication> applyForJob({
    required String jobId,
    String? coverNote,
    List<String>? documentIds,
  });
  Future<bool> updateApplicationStage(String applicationId, RelocationStage newStage);
}
