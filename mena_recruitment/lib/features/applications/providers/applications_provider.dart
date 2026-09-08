import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/applications_repository_impl.dart';
import '../domain/application_entity.dart';
import 'application_filter_provider.dart';

final applicationsRepositoryProvider = Provider((ref) => ApplicationsRepositoryImpl());

final applicationsProvider = FutureProvider<List<JobApplication>>((ref) async {
  final repo = ref.watch(applicationsRepositoryProvider);
  final filter = ref.watch(applicationFilterProvider);
  
  final allApps = await repo.getApplications();
  
  if (filter == 'All') return allApps;
  if (filter == 'Under Review') {
    return allApps.where((a) => a.currentStage == RelocationStage.screening).toList();
  }
  if (filter == 'Interviewing') {
    return allApps.where((a) => a.currentStage == RelocationStage.interview).toList();
  }
  if (filter == 'Offer & Visa') {
    return allApps.where((a) => 
      a.currentStage == RelocationStage.offerIssued || 
      a.currentStage == RelocationStage.visaProcessing).toList();
  }
  if (filter == 'Archived') {
    return [];
  }
  return allApps;
});
