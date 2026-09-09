enum RelocationStage {
  applied,
  screening,
  interview,
  offerIssued,
  visaProcessing,
  flightOnboarding,
}

enum StatusSeverity {
  verified,
  review,
  critical,
  info,
}

class JobApplication {
  final String id;
  final String jobId;
  final String jobTitle;
  final String companyName;
  final String companyLogoUrl;
  final String countryCode;
  final String city;
  final DateTime appliedDate;
  final RelocationStage currentStage;
  final String statusLabel;
  final StatusSeverity severity;
  final List<String> missingDocuments;
  final DateTime? nextDeadline;
  final String? recruiterContact;

  const JobApplication({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.companyLogoUrl,
    required this.countryCode,
    required this.city,
    required this.appliedDate,
    required this.currentStage,
    required this.statusLabel,
    required this.severity,
    this.missingDocuments = const [],
    this.nextDeadline,
    this.recruiterContact,
  });

  JobApplication copyWith({
    String? id,
    String? jobId,
    String? jobTitle,
    String? companyName,
    String? companyLogoUrl,
    String? countryCode,
    String? city,
    DateTime? appliedDate,
    RelocationStage? currentStage,
    String? statusLabel,
    StatusSeverity? severity,
    List<String>? missingDocuments,
    DateTime? nextDeadline,
    String? recruiterContact,
  }) {
    return JobApplication(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      companyLogoUrl: companyLogoUrl ?? this.companyLogoUrl,
      countryCode: countryCode ?? this.countryCode,
      city: city ?? this.city,
      appliedDate: appliedDate ?? this.appliedDate,
      currentStage: currentStage ?? this.currentStage,
      statusLabel: statusLabel ?? this.statusLabel,
      severity: severity ?? this.severity,
      missingDocuments: missingDocuments ?? this.missingDocuments,
      nextDeadline: nextDeadline ?? this.nextDeadline,
      recruiterContact: recruiterContact ?? this.recruiterContact,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'companyLogoUrl': companyLogoUrl,
      'countryCode': countryCode,
      'city': city,
      'appliedDate': appliedDate.toIso8601String(),
      'currentStage': currentStage.name,
      'statusLabel': statusLabel,
      'severity': severity.name,
      'missingDocuments': missingDocuments,
      'nextDeadline': nextDeadline?.toIso8601String(),
      'recruiterContact': recruiterContact,
    };
  }

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    final stageStr = (json['status'] as String? ?? json['currentStage'] as String? ?? 'applied').toLowerCase();
    final RelocationStage stage;
    if (stageStr.contains('flight') || stageStr.contains('onboard')) {
      stage = RelocationStage.flightOnboarding;
    } else if (stageStr.contains('visa')) {
      stage = RelocationStage.visaProcessing;
    } else if (stageStr.contains('offer')) {
      stage = RelocationStage.offerIssued;
    } else if (stageStr.contains('interview')) {
      stage = RelocationStage.interview;
    } else if (stageStr.contains('screen')) {
      stage = RelocationStage.screening;
    } else {
      stage = RelocationStage.applied;
    }

    final dateStr = json['applied_at'] ?? json['appliedDate'];
    final applied = dateStr != null ? DateTime.tryParse(dateStr.toString()) ?? DateTime.now() : DateTime.now();

    return JobApplication(
      id: json['id']?.toString() ?? '',
      jobId: json['job_id']?.toString() ?? json['jobId']?.toString() ?? '',
      jobTitle: json['job_title'] as String? ?? json['jobTitle'] as String? ?? 'Verified Vacancy',
      companyName: json['company_name'] as String? ?? json['companyName'] as String? ?? 'Verified Employer',
      companyLogoUrl: json['company_logo'] as String? ?? json['companyLogoUrl'] as String? ?? 'https://images.unsplash.com/photo-1541888946425-d0fbb1861593?w=128',
      countryCode: (json['country_code'] as String? ?? json['countryCode'] as String? ?? 'sau').toLowerCase(),
      city: json['city'] as String? ?? '',
      appliedDate: applied,
      currentStage: stage,
      statusLabel: json['statusLabel'] as String? ?? 'Stage ${stage.index + 1}/6: ${stage.name}',
      severity: StatusSeverity.values.firstWhere(
        (e) => e.name == json['severity'],
        orElse: () => StatusSeverity.info,
      ),
      missingDocuments: (json['missingDocuments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nextDeadline: json['nextDeadline'] != null
          ? DateTime.tryParse(json['nextDeadline'].toString())
          : null,
      recruiterContact: json['recruiter_contact'] as String? ?? json['recruiterContact'] as String?,
    );
  }
}
