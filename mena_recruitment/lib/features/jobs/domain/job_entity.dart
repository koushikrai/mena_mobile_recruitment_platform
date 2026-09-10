import 'package:mena_recruitment/features/jobs/domain/recruitment_region.dart';

class Job {
  final String id;
  final String title;
  final String department;
  final String companyName;
  final String companyLogoUrl;
  final String countryCode; // uae, sau, qat, kwt, omn, bhr, etc.
  final String region; // gcc, apac, emea, usa, oceania
  final String city;
  final double salaryMin;
  final double salaryMax;
  final String currency; // AED, SAR, QAR, KWD, OMR, BHD, SGD, USD, EUR, etc.
  final bool isTaxFree;
  final String visaStatus; // 'Fully Sponsored', 'Transferable Iqama', 'Visit Visa'
  final String accommodation; // 'Provided', 'Housing Allowance', 'Not Included'
  final List<String> relocationBenefits;
  final bool mofaAttestationRequired;
  final bool gamcaMedicalRequired;
  final bool iqamaTransferable;
  final bool policeClearanceRequired;
  final DateTime applicationDeadline;
  final bool isVerifiedEmployer;
  final bool isBookmarked;
  final List<String> requiredSkills;
  final String jobDescription;
  final List<String> responsibilities;
  final List<String> qualifications;
  final String requiredLanguages; // 'English', 'English / Arabic'
  final String aboutEmployer;
  final String employerSize;
  final String recruiterContact;
  final DateTime postedDate;

  const Job({
    required this.id,
    required this.title,
    required this.department,
    required this.companyName,
    required this.companyLogoUrl,
    required this.countryCode,
    this.region = 'gcc',
    required this.city,
    required this.salaryMin,
    required this.salaryMax,
    required this.currency,
    required this.isTaxFree,
    required this.visaStatus,
    required this.accommodation,
    required this.relocationBenefits,
    required this.mofaAttestationRequired,
    required this.gamcaMedicalRequired,
    required this.iqamaTransferable,
    required this.policeClearanceRequired,
    required this.applicationDeadline,
    required this.isVerifiedEmployer,
    this.isBookmarked = false,
    required this.requiredSkills,
    required this.jobDescription,
    required this.responsibilities,
    required this.qualifications,
    required this.requiredLanguages,
    required this.aboutEmployer,
    required this.employerSize,
    required this.recruiterContact,
    required this.postedDate,
  });

  Job copyWith({
    String? id,
    String? title,
    String? department,
    String? companyName,
    String? companyLogoUrl,
    String? countryCode,
    String? region,
    String? city,
    double? salaryMin,
    double? salaryMax,
    String? currency,
    bool? isTaxFree,
    String? visaStatus,
    String? accommodation,
    List<String>? relocationBenefits,
    bool? mofaAttestationRequired,
    bool? gamcaMedicalRequired,
    bool? iqamaTransferable,
    bool? policeClearanceRequired,
    DateTime? applicationDeadline,
    bool? isVerifiedEmployer,
    bool? isBookmarked,
    List<String>? requiredSkills,
    String? jobDescription,
    List<String>? responsibilities,
    List<String>? qualifications,
    String? requiredLanguages,
    String? aboutEmployer,
    String? employerSize,
    String? recruiterContact,
    DateTime? postedDate,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      department: department ?? this.department,
      companyName: companyName ?? this.companyName,
      companyLogoUrl: companyLogoUrl ?? this.companyLogoUrl,
      countryCode: countryCode ?? this.countryCode,
      region: region ?? this.region,
      city: city ?? this.city,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
      currency: currency ?? this.currency,
      isTaxFree: isTaxFree ?? this.isTaxFree,
      visaStatus: visaStatus ?? this.visaStatus,
      accommodation: accommodation ?? this.accommodation,
      relocationBenefits: relocationBenefits ?? this.relocationBenefits,
      mofaAttestationRequired: mofaAttestationRequired ?? this.mofaAttestationRequired,
      gamcaMedicalRequired: gamcaMedicalRequired ?? this.gamcaMedicalRequired,
      iqamaTransferable: iqamaTransferable ?? this.iqamaTransferable,
      policeClearanceRequired: policeClearanceRequired ?? this.policeClearanceRequired,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      isVerifiedEmployer: isVerifiedEmployer ?? this.isVerifiedEmployer,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      jobDescription: jobDescription ?? this.jobDescription,
      responsibilities: responsibilities ?? this.responsibilities,
      qualifications: qualifications ?? this.qualifications,
      requiredLanguages: requiredLanguages ?? this.requiredLanguages,
      aboutEmployer: aboutEmployer ?? this.aboutEmployer,
      employerSize: employerSize ?? this.employerSize,
      recruiterContact: recruiterContact ?? this.recruiterContact,
      postedDate: postedDate ?? this.postedDate,
    );
  }

  factory Job.fromJson(Map<String, dynamic> json) {
    final parsedCountryCode = (json['country_code'] as String? ?? json['countryCode'] as String? ?? 'sau').toLowerCase();
    return Job(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      department: json['sector'] as String? ?? json['department'] as String? ?? 'General',
      companyName: json['company_name'] as String? ?? json['companyName'] as String? ?? 'Verified Employer',
      companyLogoUrl: json['company_logo'] as String? ?? json['companyLogoUrl'] as String? ?? 'https://images.unsplash.com/photo-1541888946425-d0fbb1861593?w=128',
      countryCode: parsedCountryCode,
      region: json['region'] as String? ?? RecruitmentRegion.inferRegionFromCountry(parsedCountryCode),
      city: json['city'] as String? ?? '',
      salaryMin: (json['salary_min'] as num? ?? json['salaryMin'] as num?)?.toDouble() ?? 0.0,
      salaryMax: (json['salary_max'] as num? ?? json['salaryMax'] as num?)?.toDouble() ?? 0.0,
      currency: json['salary_currency'] as String? ?? json['currency'] as String? ?? 'SAR',
      isTaxFree: json['is_tax_free'] as bool? ?? json['isTaxFree'] as bool? ?? true,
      visaStatus: json['visa_status'] as String? ?? json['visaStatus'] as String? ?? 'Free Visa Provided',
      accommodation: json['accommodation'] as String? ?? 'Provided',
      relocationBenefits: (json['relocation_benefits'] as List<dynamic>? ?? json['relocationBenefits'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['100% Company Covered Visa', 'Flight Tickets Provided'],
      mofaAttestationRequired: json['mofa_attestation_required'] as bool? ?? true,
      gamcaMedicalRequired: json['gamca_medical_required'] as bool? ?? true,
      iqamaTransferable: json['iqama_transferable'] as bool? ?? true,
      policeClearanceRequired: json['police_clearance_required'] as bool? ?? true,
      applicationDeadline: json['application_deadline'] != null
          ? DateTime.tryParse(json['application_deadline'].toString()) ?? DateTime.now().add(const Duration(days: 30))
          : DateTime.now().add(const Duration(days: 30)),
      isVerifiedEmployer: json['is_verified_employer'] as bool? ?? json['isVerifiedEmployer'] as bool? ?? true,
      isBookmarked: json['is_bookmarked'] as bool? ?? json['isBookmarked'] as bool? ?? false,
      requiredSkills: (json['required_skills'] as List<dynamic>? ?? json['requiredSkills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      jobDescription: json['description'] as String? ?? json['jobDescription'] as String? ?? '',
      responsibilities: (json['responsibilities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          const ['Maintain zero-incident safety operations and follow standard procedures.'],
      qualifications: (json['qualifications'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          const ['Minimum 3+ years experience', 'Passport with at least 6 months validity'],
      requiredLanguages: json['required_languages'] as String? ?? 'English',
      aboutEmployer: json['about_employer'] as String? ?? 'Verified GCC Enterprise Employer',
      employerSize: json['employer_size'] as String? ?? '1,000+ Employees',
      recruiterContact: json['recruiter_contact'] as String? ?? 'recruitment@suhana-global.com',
      postedDate: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'sector': department,
      'company_name': companyName,
      'company_logo': companyLogoUrl,
      'country_code': countryCode,
      'region': region,
      'city': city,
      'salary_min': salaryMin,
      'salary_max': salaryMax,
      'salary_currency': currency,
      'is_tax_free': isTaxFree,
      'visa_status': visaStatus,
      'relocation_benefits': relocationBenefits,
      'required_skills': requiredSkills,
      'description': jobDescription,
      'is_verified_employer': isVerifiedEmployer,
      'is_bookmarked': isBookmarked,
    };
  }
}
