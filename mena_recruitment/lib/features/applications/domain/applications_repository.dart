import 'application_entity.dart';

abstract class ApplicationsRepository {
  Future<List<JobApplication>> getApplications();
  Future<JobApplication?> getApplicationById(String id);
  Future<List<JobApplication>> filterByStage(RelocationStage stage);
}
