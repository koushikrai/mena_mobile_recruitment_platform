import 'package:equatable/equatable.dart';

sealed class RealtimeEvent extends Equatable {
  final DateTime timestamp;

  const RealtimeEvent({required this.timestamp});

  static RealtimeEvent? fromJson(Map<String, dynamic> json) {
    final eventType = json['event'] as String?;
    final timeStr = json['timestamp'] as String?;
    final timestamp = timeStr != null ? DateTime.tryParse(timeStr) ?? DateTime.now() : DateTime.now();
    final data = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : <String, dynamic>{};

    switch (eventType) {
      case 'connection_established':
        return ConnectionEstablishedEvent(
          timestamp: timestamp,
          isAuthenticated: data['authenticated'] as bool? ?? false,
          userId: data['user_id'] as String?,
        );

      case 'pipeline_stage_changed':
        return PipelineStageChangedEvent(
          timestamp: timestamp,
          applicationId: data['application_id'] as String? ?? '',
          jobId: data['job_id'] as String? ?? '',
          newStatus: data['new_status'] as String? ?? '',
          newStage: data['new_stage'] as String? ?? '',
          title: data['title'] as String? ?? 'Stage Updated',
          description: data['description'] as String? ?? '',
        );

      case 'application_created':
        return ApplicationCreatedEvent(
          timestamp: timestamp,
          applicationId: data['application_id'] as String? ?? '',
          jobId: data['job_id'] as String? ?? '',
          jobTitle: data['job_title'] as String? ?? '',
          companyName: data['company_name'] as String? ?? '',
          status: data['status'] as String? ?? 'applied',
        );

      case 'walkin_quota_updated':
        return WalkinQuotaUpdatedEvent(
          timestamp: timestamp,
          driveId: data['drive_id'] as String? ?? '',
          title: data['title'] as String? ?? '',
          registeredCount: (data['registered_count'] as num?)?.toInt() ?? 0,
          availableQuotas: (data['available_quotas'] as num?)?.toInt() ?? 0,
          remainingSlots: (data['remaining_slots'] as num?)?.toInt() ?? 0,
        );

      case 'walkin_registered':
        return WalkinRegisteredEvent(
          timestamp: timestamp,
          driveId: data['drive_id'] as String? ?? '',
          registrationId: data['registration_id'] as String? ?? '',
          qrPassCode: data['qr_pass_code'] as String? ?? '',
          timeSlot: data['time_slot'] as String? ?? '',
          title: data['title'] as String? ?? '',
          venue: data['venue'] as String? ?? '',
        );

      case 'document_status_updated':
        return DocumentStatusUpdatedEvent(
          timestamp: timestamp,
          documentId: data['document_id'] as String? ?? '',
          documentType: data['document_type'] as String? ?? '',
          verificationStatus: data['verification_status'] as String? ?? '',
          isVerified: data['is_verified'] as bool? ?? false,
          fileName: data['file_name'] as String? ?? '',
        );

      case 'readiness_score_updated':
        return ReadinessScoreUpdatedEvent(
          timestamp: timestamp,
          score: (data['relocation_readiness_score'] as num?)?.toInt() ?? 0,
        );

      case 'compliance_alert':
        return ComplianceAlertEvent(
          timestamp: timestamp,
          alertType: data['alert_type'] as String? ?? 'general',
          message: data['message'] as String? ?? '',
          deadline: data['deadline'] as String?,
        );

      default:
        return GenericRealtimeEvent(
          eventType: eventType ?? 'unknown',
          data: data,
          timestamp: timestamp,
        );
    }
  }

  @override
  List<Object?> get props => [timestamp];
}

class ConnectionEstablishedEvent extends RealtimeEvent {
  final bool isAuthenticated;
  final String? userId;

  const ConnectionEstablishedEvent({
    required super.timestamp,
    required this.isAuthenticated,
    this.userId,
  });

  @override
  List<Object?> get props => [timestamp, isAuthenticated, userId];
}

class PipelineStageChangedEvent extends RealtimeEvent {
  final String applicationId;
  final String jobId;
  final String newStatus;
  final String newStage;
  final String title;
  final String description;

  const PipelineStageChangedEvent({
    required super.timestamp,
    required this.applicationId,
    required this.jobId,
    required this.newStatus,
    required this.newStage,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [timestamp, applicationId, jobId, newStatus, newStage, title, description];
}

class ApplicationCreatedEvent extends RealtimeEvent {
  final String applicationId;
  final String jobId;
  final String jobTitle;
  final String companyName;
  final String status;

  const ApplicationCreatedEvent({
    required super.timestamp,
    required this.applicationId,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.status,
  });

  @override
  List<Object?> get props => [timestamp, applicationId, jobId, jobTitle, companyName, status];
}

class WalkinQuotaUpdatedEvent extends RealtimeEvent {
  final String driveId;
  final String title;
  final int registeredCount;
  final int availableQuotas;
  final int remainingSlots;

  const WalkinQuotaUpdatedEvent({
    required super.timestamp,
    required this.driveId,
    required this.title,
    required this.registeredCount,
    required this.availableQuotas,
    required this.remainingSlots,
  });

  @override
  List<Object?> get props => [timestamp, driveId, title, registeredCount, availableQuotas, remainingSlots];
}

class WalkinRegisteredEvent extends RealtimeEvent {
  final String driveId;
  final String registrationId;
  final String qrPassCode;
  final String timeSlot;
  final String title;
  final String venue;

  const WalkinRegisteredEvent({
    required super.timestamp,
    required this.driveId,
    required this.registrationId,
    required this.qrPassCode,
    required this.timeSlot,
    required this.title,
    required this.venue,
  });

  @override
  List<Object?> get props => [timestamp, driveId, registrationId, qrPassCode, timeSlot, title, venue];
}

class DocumentStatusUpdatedEvent extends RealtimeEvent {
  final String documentId;
  final String documentType;
  final String verificationStatus;
  final bool isVerified;
  final String fileName;

  const DocumentStatusUpdatedEvent({
    required super.timestamp,
    required this.documentId,
    required this.documentType,
    required this.verificationStatus,
    required this.isVerified,
    required this.fileName,
  });

  @override
  List<Object?> get props => [timestamp, documentId, documentType, verificationStatus, isVerified, fileName];
}

class ReadinessScoreUpdatedEvent extends RealtimeEvent {
  final int score;

  const ReadinessScoreUpdatedEvent({
    required super.timestamp,
    required this.score,
  });

  @override
  List<Object?> get props => [timestamp, score];
}

class ComplianceAlertEvent extends RealtimeEvent {
  final String alertType;
  final String message;
  final String? deadline;

  const ComplianceAlertEvent({
    required super.timestamp,
    required this.alertType,
    required this.message,
    this.deadline,
  });

  @override
  List<Object?> get props => [timestamp, alertType, message, deadline];
}

class GenericRealtimeEvent extends RealtimeEvent {
  final String eventType;
  final Map<String, dynamic> data;

  const GenericRealtimeEvent({
    required super.timestamp,
    required this.eventType,
    required this.data,
  });

  @override
  List<Object?> get props => [timestamp, eventType, data];
}
