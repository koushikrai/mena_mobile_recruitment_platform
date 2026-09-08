import '../domain/application_entity.dart';
import '../domain/applications_repository.dart';
import 'mock_applications_data.dart';

class ApplicationsRepositoryImpl implements ApplicationsRepository {
  @override
  Future<List<JobApplication>> getApplications() async {
    await Future.delayed(const Duration(seconds: 1));
    return mockApplications;
  }

  @override
  Future<JobApplication?> getApplicationById(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      return mockApplications.firstWhere((app) => app.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<JobApplication>> filterByStage(RelocationStage stage) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockApplications.where((app) => app.currentStage == stage).toList();
  }
}
