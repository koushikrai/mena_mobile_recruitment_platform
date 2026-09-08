class Job {
  final String id;
  final String title;
  final String department;
  final String companyName;
  final String companyLogoUrl;
  final String countryCode; // uae, sau, qat, kwt, omn, bhr
  final String city;
  final double salaryMin;
  final double salaryMax;
  final String currency; // AED, SAR, QAR, KWD, OMR, BHD
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
}
