class WalkinDrive {
  final String id;
  final String? companyName;
  final String title;
  final String countryCode;
  final String city;
  final String venueName;
  final String venueAddress;
  final String startDate;
  final String endDate;
  final List<String> timeSlots;
  final int availableQuotas;
  final int registeredCount;
  final String qrCodePrefix;
  final bool isActive;

  const WalkinDrive({
    required this.id,
    this.companyName,
    required this.title,
    required this.countryCode,
    required this.city,
    required this.venueName,
    required this.venueAddress,
    required this.startDate,
    required this.endDate,
    required this.timeSlots,
    required this.availableQuotas,
    required this.registeredCount,
    required this.qrCodePrefix,
    required this.isActive,
  });

  factory WalkinDrive.fromJson(Map<String, dynamic> json) {
    return WalkinDrive(
      id: json['id']?.toString() ?? '',
      companyName: json['company_name'] as String?,
      title: json['title'] as String? ?? 'Mega Walk-In Recruitment Drive',
      countryCode: json['country_code'] as String? ?? 'KSA',
      city: json['city'] as String? ?? 'Yanbu',
      venueName: json['venue_name'] as String? ?? 'Yanbu Industrial City Convention Hub',
      venueAddress: json['venue_address'] as String? ?? 'Gate 3, Royal Commission Industrial Area, Yanbu, KSA',
      startDate: json['start_date'] as String? ?? '2025-11-12',
      endDate: json['end_date'] as String? ?? '2025-11-14',
      timeSlots: (json['time_slots'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [
        '12 Nov - Morning (08:30 AM)',
        '12 Nov - Afternoon (01:30 PM)',
        '13 Nov - Morning (08:30 AM)',
        '13 Nov - Afternoon (01:30 PM)',
        '14 Nov - Jubail Final Session (09:00 AM)',
      ],
      availableQuotas: (json['available_quotas'] as num?)?.toInt() ?? 1200,
      registeredCount: (json['registered_count'] as num?)?.toInt() ?? 420,
      qrCodePrefix: json['qr_code_prefix'] as String? ?? 'KSA-WALKIN-2025-',
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

class WalkinRegistration {
  final String id;
  final String driveId;
  final String timeSlot;
  final String qrPassCode;
  final String status;
  final DateTime registeredAt;

  const WalkinRegistration({
    required this.id,
    required this.driveId,
    required this.timeSlot,
    required this.qrPassCode,
    required this.status,
    required this.registeredAt,
  });

  factory WalkinRegistration.fromJson(Map<String, dynamic> json) {
    return WalkinRegistration(
      id: json['id']?.toString() ?? '',
      driveId: json['drive_id']?.toString() ?? '',
      timeSlot: json['time_slot'] as String? ?? '',
      qrPassCode: json['qr_pass_code'] as String? ?? 'KSA-WALKIN-2025-PASS',
      status: json['status'] as String? ?? 'registered',
      registeredAt: json['registered_at'] != null
          ? DateTime.tryParse(json['registered_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
