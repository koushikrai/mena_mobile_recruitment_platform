import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/profile/domain/candidate_profile_entity.dart';
import 'package:mena_recruitment/features/profile/providers/profile_provider.dart';
import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';
import 'package:mena_recruitment/features/vault/providers/vault_provider.dart';

// ── Models for each stage ────────────────────────────────────────────────────

class ManualBasicDetails {
  final String fullName;
  final String targetTitle;
  final String email;
  final String phone;
  final String countryCode;
  final String nationality;
  final String residentCountry;
  final String city;

  const ManualBasicDetails({
    this.fullName = '',
    this.targetTitle = '',
    this.email = '',
    this.phone = '',
    this.countryCode = '+966',
    this.nationality = '',
    this.residentCountry = '',
    this.city = '',
  });

  ManualBasicDetails copyWith({
    String? fullName,
    String? targetTitle,
    String? email,
    String? phone,
    String? countryCode,
    String? nationality,
    String? residentCountry,
    String? city,
  }) {
    return ManualBasicDetails(
      fullName: fullName ?? this.fullName,
      targetTitle: targetTitle ?? this.targetTitle,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      nationality: nationality ?? this.nationality,
      residentCountry: residentCountry ?? this.residentCountry,
      city: city ?? this.city,
    );
  }
}

class ManualWorkExperience {
  final String id;
  final String title;
  final String company;
  final String location;
  final String dates;
  final bool isCurrent;
  final List<String> responsibilities;

  const ManualWorkExperience({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.dates,
    required this.isCurrent,
    this.responsibilities = const [],
  });

  ManualWorkExperience copyWith({
    String? id,
    String? title,
    String? company,
    String? location,
    String? dates,
    bool? isCurrent,
    List<String>? responsibilities,
  }) {
    return ManualWorkExperience(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      dates: dates ?? this.dates,
      isCurrent: isCurrent ?? this.isCurrent,
      responsibilities: responsibilities ?? this.responsibilities,
    );
  }
}

class ManualEducation {
  final String id;
  final String degree;
  final String fieldOfStudy;
  final String institution;
  final String graduationYear;
  final String? grade;

  const ManualEducation({
    required this.id,
    required this.degree,
    required this.fieldOfStudy,
    required this.institution,
    required this.graduationYear,
    this.grade,
  });

  ManualEducation copyWith({
    String? id,
    String? degree,
    String? fieldOfStudy,
    String? institution,
    String? graduationYear,
    String? grade,
  }) {
    return ManualEducation(
      id: id ?? this.id,
      degree: degree ?? this.degree,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      institution: institution ?? this.institution,
      graduationYear: graduationYear ?? this.graduationYear,
      grade: grade ?? this.grade,
    );
  }
}

class ManualCertification {
  final String id;
  final String title;
  final String issuer;
  final String credentialNumber;
  final String issueYear;
  final String expiryYear;
  final bool isVerified;

  const ManualCertification({
    required this.id,
    required this.title,
    required this.issuer,
    required this.credentialNumber,
    required this.issueYear,
    required this.expiryYear,
    this.isVerified = true,
  });

  ManualCertification copyWith({
    String? id,
    String? title,
    String? issuer,
    String? credentialNumber,
    String? issueYear,
    String? expiryYear,
    bool? isVerified,
  }) {
    return ManualCertification(
      id: id ?? this.id,
      title: title ?? this.title,
      issuer: issuer ?? this.issuer,
      credentialNumber: credentialNumber ?? this.credentialNumber,
      issueYear: issueYear ?? this.issueYear,
      expiryYear: expiryYear ?? this.expiryYear,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

class ManualSalaryRelocation {
  final double currentSalary;
  final String currentCurrency;
  final double expectedSalary;
  final String expectedCurrency;
  final String noticePeriod;
  final String relocationDate;
  final List<String> preferredCountries;
  final String? resumeFileName;

  const ManualSalaryRelocation({
    this.currentSalary = 0.0,
    this.currentCurrency = 'SAR',
    this.expectedSalary = 0.0,
    this.expectedCurrency = 'SAR',
    this.noticePeriod = '',
    this.relocationDate = '',
    this.preferredCountries = const [],
    this.resumeFileName,
  });

  const ManualSalaryRelocation.empty({this.resumeFileName})
      : currentSalary = 0.0,
        currentCurrency = 'SAR',
        expectedSalary = 0.0,
        expectedCurrency = 'SAR',
        noticePeriod = '',
        relocationDate = '',
        preferredCountries = const [];

  ManualSalaryRelocation copyWith({
    double? currentSalary,
    String? currentCurrency,
    double? expectedSalary,
    String? expectedCurrency,
    String? noticePeriod,
    String? relocationDate,
    List<String>? preferredCountries,
    String? resumeFileName,
  }) {
    return ManualSalaryRelocation(
      currentSalary: currentSalary ?? this.currentSalary,
      currentCurrency: currentCurrency ?? this.currentCurrency,
      expectedSalary: expectedSalary ?? this.expectedSalary,
      expectedCurrency: expectedCurrency ?? this.expectedCurrency,
      noticePeriod: noticePeriod ?? this.noticePeriod,
      relocationDate: relocationDate ?? this.relocationDate,
      preferredCountries: preferredCountries ?? this.preferredCountries,
      resumeFileName: resumeFileName ?? this.resumeFileName,
    );
  }
}

// ── Overall Multi-Stage State ────────────────────────────────────────────────

class ManualProfileState {
  final int currentStage; // 0 = Basic Details, 1 = Experience & Education, 2 = Skills & Certifications, 3 = Salary & Relocation
  final ManualBasicDetails basicDetails;
  final List<ManualWorkExperience> workExperiences;
  final List<ManualEducation> educations;
  final List<ManualCertification> certifications;
  final List<String> skills;
  final ManualSalaryRelocation salaryRelocation;
  final bool isSubmitting;

  const ManualProfileState({
    this.currentStage = 0,
    this.basicDetails = const ManualBasicDetails(),
    this.workExperiences = const [],
    this.educations = const [],
    this.certifications = const [],
    this.skills = const [],
    this.salaryRelocation = const ManualSalaryRelocation.empty(),
    this.isSubmitting = false,
  });

  ManualProfileState copyWith({
    int? currentStage,
    ManualBasicDetails? basicDetails,
    List<ManualWorkExperience>? workExperiences,
    List<ManualEducation>? educations,
    List<ManualCertification>? certifications,
    List<String>? skills,
    ManualSalaryRelocation? salaryRelocation,
    bool? isSubmitting,
  }) {
    return ManualProfileState(
      currentStage: currentStage ?? this.currentStage,
      basicDetails: basicDetails ?? this.basicDetails,
      workExperiences: workExperiences ?? this.workExperiences,
      educations: educations ?? this.educations,
      certifications: certifications ?? this.certifications,
      skills: skills ?? this.skills,
      salaryRelocation: salaryRelocation ?? this.salaryRelocation,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

// ── State Notifier ───────────────────────────────────────────────────────────

class ManualProfileNotifier extends StateNotifier<ManualProfileState> {
  ManualProfileNotifier() : super(_initialState());

  static ManualProfileState _initialState() {
    return const ManualProfileState(
      currentStage: 0,
      basicDetails: ManualBasicDetails(),
      workExperiences: [],
      educations: [],
      certifications: [],
      skills: [],
      salaryRelocation: ManualSalaryRelocation.empty(),
    );
  }

  void reset() {
    state = _initialState();
  }

  void setStage(int stage) {
    if (stage >= 0 && stage <= 3) {
      state = state.copyWith(currentStage: stage);
    }
  }

  void nextStage() {
    if (state.currentStage < 3) {
      state = state.copyWith(currentStage: state.currentStage + 1);
    }
  }

  void prevStage() {
    if (state.currentStage > 0) {
      state = state.copyWith(currentStage: state.currentStage - 1);
    }
  }

  /// Injects structured resume data parsed by Gemini AI into the candidate form.
  /// Sets currentStage to 0 (Stage 1: Basic Details) for step-by-step verification.
  void applyParsedResumeData({
    required ManualBasicDetails basicDetails,
    required List<ManualWorkExperience> workExperiences,
    required List<ManualEducation> educations,
    required List<ManualCertification> certifications,
    required List<String> skills,
    required ManualSalaryRelocation salaryRelocation,
  }) {
    state = state.copyWith(
      currentStage: 0,
      basicDetails: basicDetails,
      workExperiences: workExperiences,
      educations: educations,
      certifications: certifications,
      skills: skills,
      salaryRelocation: salaryRelocation,
    );
  }

  // ── Stage 1: Basic Details ─────────────────────────────────────────────────
  void updateBasicDetails(ManualBasicDetails details) {
    state = state.copyWith(basicDetails: details);
  }

  // ── Stage 2: Experience & Education ────────────────────────────────────────
  void addWorkExperience(ManualWorkExperience item) {
    state = state.copyWith(workExperiences: [...state.workExperiences, item]);
  }

  void updateWorkExperience(int index, ManualWorkExperience item) {
    if (index >= 0 && index < state.workExperiences.length) {
      final updated = List<ManualWorkExperience>.from(state.workExperiences);
      updated[index] = item;
      state = state.copyWith(workExperiences: updated);
    }
  }

  void deleteWorkExperience(int index) {
    if (index >= 0 && index < state.workExperiences.length) {
      final updated = List<ManualWorkExperience>.from(state.workExperiences)..removeAt(index);
      state = state.copyWith(workExperiences: updated);
    }
  }

  void addEducation(ManualEducation item) {
    state = state.copyWith(educations: [...state.educations, item]);
  }

  void updateEducation(int index, ManualEducation item) {
    if (index >= 0 && index < state.educations.length) {
      final updated = List<ManualEducation>.from(state.educations);
      updated[index] = item;
      state = state.copyWith(educations: updated);
    }
  }

  void deleteEducation(int index) {
    if (index >= 0 && index < state.educations.length) {
      final updated = List<ManualEducation>.from(state.educations)..removeAt(index);
      state = state.copyWith(educations: updated);
    }
  }

  // ── Stage 3: Certifications ────────────────────────────────────────────────
  void addCertification(ManualCertification item) {
    state = state.copyWith(certifications: [...state.certifications, item]);
  }

  void updateCertification(int index, ManualCertification item) {
    if (index >= 0 && index < state.certifications.length) {
      final updated = List<ManualCertification>.from(state.certifications);
      updated[index] = item;
      state = state.copyWith(certifications: updated);
    }
  }

  void deleteCertification(int index) {
    if (index >= 0 && index < state.certifications.length) {
      final updated = List<ManualCertification>.from(state.certifications)..removeAt(index);
      state = state.copyWith(certifications: updated);
    }
  }

  // ── Stage 3: Skills ────────────────────────────────────────────────────────
  void addSkill(String skill) {
    final trimmed = skill.trim();
    if (trimmed.isNotEmpty && !state.skills.contains(trimmed)) {
      state = state.copyWith(skills: [...state.skills, trimmed]);
    }
  }

  void removeSkill(String skill) {
    state = state.copyWith(
      skills: state.skills.where((s) => s != skill).toList(),
    );
  }

  void setSkills(List<String> skills) {
    state = state.copyWith(skills: skills);
  }

  // ── Stage 4: Salary & Relocation ───────────────────────────────────────────
  void updateSalaryRelocation(ManualSalaryRelocation salaryRelocation) {
    state = state.copyWith(salaryRelocation: salaryRelocation);
  }

  void setResumeFileName(String? fileName) {
    state = state.copyWith(
      salaryRelocation: state.salaryRelocation.copyWith(resumeFileName: fileName),
    );
  }

  // ── Final Submission ───────────────────────────────────────────────────────
  Future<bool> submitCompleteProfile(WidgetRef ref) async {
    state = state.copyWith(isSubmitting: true);
    try {
      final currentProfile = ref.read(profileProvider).value;
      
      final expCount = state.workExperiences.isNotEmpty ? state.workExperiences.length * 3 : 7;
      final gccCount = state.workExperiences.where((e) => e.location.toLowerCase().contains('saudi') || e.location.toLowerCase().contains('uae') || e.location.toLowerCase().contains('qatar')).length * 3;

      final updatedProfile = CandidateProfile(
        id: currentProfile?.id ?? 'cand-manual-profile',
        uid: currentProfile?.uid ?? 'SUH-${DateTime.now().millisecondsSinceEpoch % 100000}',
        fullName: state.basicDetails.fullName.trim(),
        email: state.basicDetails.email.trim(),
        phone: '${state.basicDetails.countryCode} ${state.basicDetails.phone.trim()}',
        nationality: state.basicDetails.nationality,
        residentCountry: state.basicDetails.residentCountry,
        targetTitle: state.basicDetails.targetTitle.trim(),
        totalExperience: expCount,
        gccExperience: gccCount > 0 ? gccCount : 3,
        readinessScore: 92,
        isActivelyLooking: true,
        preferredCountries: state.salaryRelocation.preferredCountries,
        expectedSalary: state.salaryRelocation.expectedSalary,
        expectedCurrency: state.salaryRelocation.expectedCurrency,
        noticePeriod: state.salaryRelocation.noticePeriod,
        relocationStatus: state.salaryRelocation.relocationDate,
        isGccVerified: true,
      );

      await ref.read(profileRepositoryProvider).updateProfile(updatedProfile);

      for (final cert in state.certifications) {
        try {
          final vaultDoc = VaultDocument(
            id: 'vault-${cert.id}',
            category: DocumentCategory.tradeLicense,
            title: cert.title,
            documentNumber: cert.credentialNumber,
            issuingCountry: cert.issuer,
            isVerified: cert.isVerified,
            isValidForGccVisa: true,
          );
          await ref.read(vaultRepositoryProvider).addDocument(vaultDoc);
        } catch (_) {}
      }

      ref.invalidate(profileProvider);
      ref.invalidate(vaultDocumentsProvider);
      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (_) {
      state = state.copyWith(isSubmitting: false);
      return false;
    }
  }
}

final manualProfileProvider = StateNotifierProvider<ManualProfileNotifier, ManualProfileState>((ref) {
  return ManualProfileNotifier();
});
