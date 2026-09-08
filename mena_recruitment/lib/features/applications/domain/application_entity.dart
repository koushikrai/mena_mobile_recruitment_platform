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
    return JobApplication(
      id: json['id'] as String,
      jobId: json['jobId'] as String,
      jobTitle: json['jobTitle'] as String,
      companyName: json['companyName'] as String,
      companyLogoUrl: json['companyLogoUrl'] as String,
      countryCode: json['countryCode'] as String,
      city: json['city'] as String,
      appliedDate: DateTime.parse(json['appliedDate'] as String),
      currentStage: RelocationStage.values.firstWhere(
        (e) => e.name == json['currentStage'],
        orElse: () => RelocationStage.applied,
      ),
      statusLabel: json['statusLabel'] as String,
      severity: StatusSeverity.values.firstWhere(
        (e) => e.name == json['severity'],
        orElse: () => StatusSeverity.info,
      ),
      missingDocuments: (json['missingDocuments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nextDeadline: json['nextDeadline'] != null
          ? DateTime.parse(json['nextDeadline'] as String)
          : null,
      recruiterContact: json['recruiterContact'] as String?,
    );
  }
}
