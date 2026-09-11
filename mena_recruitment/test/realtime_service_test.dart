import 'package:flutter_test/flutter_test.dart';
import 'package:mena_recruitment/core/network/realtime_event.dart';
import 'package:mena_recruitment/core/network/realtime_service.dart';
import 'package:mena_recruitment/features/applications/domain/application_entity.dart';

void main() {
  group('RealtimeEvent Deserialization Tests', () {
    test('PipelineStageChangedEvent parses accurately from backend JSON', () {
      final json = {
        'event': 'pipeline_stage_changed',
        'timestamp': '2026-09-11T12:00:00Z',
        'data': {
          'application_id': 'app-101',
          'job_id': 'job-505',
          'new_status': 'visa_processing',
          'new_stage': 'visa_processing',
          'title': 'Visa Quota Allocated',
          'description': 'Qiwa contract authorized by Saudi MHRSD',
        }
      };

      final event = RealtimeEvent.fromJson(json);
      expect(event, isA<PipelineStageChangedEvent>());

      final stageEvent = event as PipelineStageChangedEvent;
      expect(stageEvent.applicationId, equals('app-101'));
      expect(stageEvent.jobId, equals('job-505'));
      expect(stageEvent.newStage, equals('visa_processing'));
      expect(stageEvent.title, equals('Visa Quota Allocated'));
      expect(stageEvent.description, contains('Qiwa'));
    });

    test('WalkinQuotaUpdatedEvent parses quota counters correctly', () {
      final json = {
        'event': 'walkin_quota_updated',
        'timestamp': '2026-09-11T12:05:00Z',
        'data': {
          'drive_id': 'drive-yanbu-2025',
          'title': 'Oil & Gas Turnaround 2025',
          'registered_count': 421,
          'available_quotas': 1200,
          'remaining_slots': 779,
        }
      };

      final event = RealtimeEvent.fromJson(json);
      expect(event, isA<WalkinQuotaUpdatedEvent>());

      final quotaEvent = event as WalkinQuotaUpdatedEvent;
      expect(quotaEvent.driveId, equals('drive-yanbu-2025'));
      expect(quotaEvent.registeredCount, equals(421));
      expect(quotaEvent.availableQuotas, equals(1200));
      expect(quotaEvent.remainingSlots, equals(779));
    });

    test('DocumentStatusUpdatedEvent and ReadinessScoreUpdatedEvent parse correctly', () {
      final docJson = {
        'event': 'document_status_updated',
        'timestamp': '2026-09-11T12:10:00Z',
        'data': {
          'document_id': 'doc-77',
          'document_type': 'passport',
          'verification_status': 'verified',
          'is_verified': true,
          'file_name': 'Passport_Scan.pdf',
        }
      };

      final docEvent = RealtimeEvent.fromJson(docJson);
      expect(docEvent, isA<DocumentStatusUpdatedEvent>());
      final d = docEvent as DocumentStatusUpdatedEvent;
      expect(d.isVerified, isTrue);
      expect(d.documentType, equals('passport'));

      final scoreJson = {
        'event': 'readiness_score_updated',
        'timestamp': '2026-09-11T12:10:05Z',
        'data': {
          'relocation_readiness_score': 92,
        }
      };

      final scoreEvent = RealtimeEvent.fromJson(scoreJson);
      expect(scoreEvent, isA<ReadinessScoreUpdatedEvent>());
      expect((scoreEvent as ReadinessScoreUpdatedEvent).score, equals(92));
    });

    test('ConnectionEstablishedEvent parses authentication state', () {
      final json = {
        'event': 'connection_established',
        'timestamp': '2026-09-11T12:15:00Z',
        'data': {
          'status': 'connected',
          'authenticated': true,
          'user_id': 'usr-999',
        }
      };

      final event = RealtimeEvent.fromJson(json);
      expect(event, isA<ConnectionEstablishedEvent>());
      final connEvent = event as ConnectionEstablishedEvent;
      expect(connEvent.isAuthenticated, isTrue);
      expect(connEvent.userId, equals('usr-999'));
    });
  });

  group('JobApplication RelocationStage mapping', () {
    test('JobApplication maps new realtime stage to RelocationStage enum', () {
      final appJson = {
        'id': 'app-test',
        'job_id': 'job-test',
        'status': 'visa_processing',
        'job_title': 'Senior HSE Supervisor',
        'company_name': 'PetroGulf Energy',
        'country_code': 'KSA',
        'city': 'Dammam',
      };

      final app = JobApplication.fromJson(appJson);
      expect(app.currentStage, equals(RelocationStage.visaProcessing));

      final flightApp = app.copyWith(
        currentStage: RelocationStage.flightOnboarding,
        statusLabel: 'Stage 6/6: Flight & Onboarding',
      );
      expect(flightApp.currentStage, equals(RelocationStage.flightOnboarding));
      expect(flightApp.statusLabel, contains('Flight'));
    });
  });
}
