import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/core/network/realtime_provider.dart';
import 'package:mena_recruitment/core/network/realtime_event.dart';
import '../data/applications_repository_impl.dart';
import '../domain/application_entity.dart';
import '../domain/applications_repository.dart';
import 'application_filter_provider.dart';

final applicationsRepositoryProvider = Provider<ApplicationsRepository>((ref) {
  return ApplicationsRepositoryImpl();
});

class ApplicationsNotifier extends AsyncNotifier<List<JobApplication>> {
  StreamSubscription<RealtimeEvent>? _realtimeSub;

  @override
  Future<List<JobApplication>> build() async {
    final repo = ref.watch(applicationsRepositoryProvider);
    final filter = ref.watch(applicationFilterProvider);

    // Subscribe to realtime stream if not already active
    _subscribeToRealtimeEvents();

    final allApps = await repo.getApplications();
    return _applyFilter(allApps, filter);
  }

  void _subscribeToRealtimeEvents() {
    _realtimeSub?.cancel();
    final realtimeService = ref.read(realtimeServiceProvider);
    
    // Connect to realtime WebSocket if not already connected
    realtimeService.connect();

    _realtimeSub = realtimeService.events.listen((event) {
      if (event is PipelineStageChangedEvent) {
        _handleStageChangedEvent(event);
      } else if (event is ApplicationCreatedEvent) {
        _handleApplicationCreatedEvent(event);
      }
    });

    ref.onDispose(() {
      _realtimeSub?.cancel();
    });
  }

  void _handleStageChangedEvent(PipelineStageChangedEvent event) {
    final currentList = state.value;
    if (currentList == null) return;

    final idx = currentList.indexWhere(
      (a) => a.id == event.applicationId || (event.jobId.isNotEmpty && a.jobId == event.jobId),
    );

    if (idx != -1) {
      final existing = currentList[idx];
      final stage = _parseRelocationStage(event.newStage);
      final updatedApp = existing.copyWith(
        currentStage: stage,
        statusLabel: event.title.isNotEmpty
            ? 'Stage ${stage.index + 1}/6: ${event.title}'
            : 'Stage ${stage.index + 1}/6: ${stage.name}',
        severity: stage == RelocationStage.visaProcessing || stage == RelocationStage.offerIssued
            ? StatusSeverity.verified
            : StatusSeverity.info,
      );

      final updatedList = List<JobApplication>.from(currentList);
      updatedList[idx] = updatedApp;
      state = AsyncValue.data(updatedList);
    } else {
      // If application not in filtered list, trigger soft refresh
      refresh();
    }
  }

  void _handleApplicationCreatedEvent(ApplicationCreatedEvent event) {
    refresh();
  }

  RelocationStage _parseRelocationStage(String stageStr) {
    final s = stageStr.toLowerCase();
    if (s.contains('flight') || s.contains('onboard')) {
      return RelocationStage.flightOnboarding;
    } else if (s.contains('visa')) {
      return RelocationStage.visaProcessing;
    } else if (s.contains('offer')) {
      return RelocationStage.offerIssued;
    } else if (s.contains('interview')) {
      return RelocationStage.interview;
    } else if (s.contains('screen')) {
      return RelocationStage.screening;
    }
    return RelocationStage.applied;
  }

  List<JobApplication> _applyFilter(List<JobApplication> allApps, String filter) {
    if (filter == 'All') return allApps;
    if (filter == 'Under Review') {
      return allApps.where((a) => a.currentStage == RelocationStage.screening).toList();
    }
    if (filter == 'Interviewing') {
      return allApps.where((a) => a.currentStage == RelocationStage.interview).toList();
    }
    if (filter == 'Offer & Visa') {
      return allApps
          .where((a) =>
              a.currentStage == RelocationStage.offerIssued ||
              a.currentStage == RelocationStage.visaProcessing)
          .toList();
    }
    if (filter == 'Archived') {
      return [];
    }
    return allApps;
  }

  Future<void> refresh() async {
    final repo = ref.read(applicationsRepositoryProvider);
    final filter = ref.read(applicationFilterProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final allApps = await repo.getApplications();
      return _applyFilter(allApps, filter);
    });
  }

  Future<bool> advanceStage(String applicationId, RelocationStage newStage) async {
    final repo = ref.read(applicationsRepositoryProvider);
    final success = await repo.updateApplicationStage(applicationId, newStage);
    if (success) {
      await refresh();
    }
    return success;
  }
}

final applicationsProvider =
    AsyncNotifierProvider<ApplicationsNotifier, List<JobApplication>>(() {
  return ApplicationsNotifier();
});
