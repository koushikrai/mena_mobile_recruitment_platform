import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'realtime_service.dart';
import 'realtime_event.dart';

final realtimeServiceProvider = Provider<RealtimeService>((ref) {
  final service = RealtimeService();
  ref.onDispose(() {
    // Keep alive across screens or dispose if container disposed
  });
  return service;
});

final realtimeStatusProvider = StreamProvider<RealtimeConnectionStatus>((ref) {
  final service = ref.watch(realtimeServiceProvider);
  return service.statusStream;
});

final realtimeEventsProvider = StreamProvider<RealtimeEvent>((ref) {
  final service = ref.watch(realtimeServiceProvider);
  return service.events;
});

final pipelineUpdatesProvider = StreamProvider<PipelineStageChangedEvent>((ref) {
  final service = ref.watch(realtimeServiceProvider);
  return service.events.where((e) => e is PipelineStageChangedEvent).cast<PipelineStageChangedEvent>();
});

final walkinQuotaStreamProvider = StreamProvider<WalkinQuotaUpdatedEvent>((ref) {
  final service = ref.watch(realtimeServiceProvider);
  // Subscribe to topic:walkin_drives
  service.subscribeTopic('topic:walkin_drives');
  return service.events.where((e) => e is WalkinQuotaUpdatedEvent).cast<WalkinQuotaUpdatedEvent>();
});
