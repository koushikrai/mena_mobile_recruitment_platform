class ParsedCV {
  final String fullName;
  final String email;
  final String phone;
  final String nationality;
  final String residentCountry;
  final String targetTitle;
  final double totalExperience;
  final double gccExperience;
  final List<WorkExperience> experiences;
  final List<EducationEntry> education;
  final List<String> skills;

  const ParsedCV({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.nationality,
    required this.residentCountry,
    required this.targetTitle,
    required this.totalExperience,
    required this.gccExperience,
    this.experiences = const [],
    this.education = const [],
    this.skills = const [],
  });

  ParsedCV copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? nationality,
    String? residentCountry,
    String? targetTitle,
    double? totalExperience,
    double? gccExperience,
    List<WorkExperience>? experiences,
    List<EducationEntry>? education,
    List<String>? skills,
  }) {
    return ParsedCV(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      nationality: nationality ?? this.nationality,
      residentCountry: residentCountry ?? this.residentCountry,
      targetTitle: targetTitle ?? this.targetTitle,
      totalExperience: totalExperience ?? this.totalExperience,
      gccExperience: gccExperience ?? this.gccExperience,
      experiences: experiences ?? this.experiences,
      education: education ?? this.education,
      skills: skills ?? this.skills,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'nationality': nationality,
      'residentCountry': residentCountry,
      'targetTitle': targetTitle,
      'totalExperience': totalExperience,
      'gccExperience': gccExperience,
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'education': education.map((e) => e.toJson()).toList(),
      'skills': skills,
    };
  }

  factory ParsedCV.fromJson(Map<String, dynamic> json) {
    return ParsedCV(
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      nationality: json['nationality'] as String? ?? '',
      residentCountry: json['residentCountry'] as String? ?? '',
      targetTitle: json['targetTitle'] as String? ?? '',
      totalExperience: (json['totalExperience'] as num?)?.toDouble() ?? 0.0,
      gccExperience: (json['gccExperience'] as num?)?.toDouble() ?? 0.0,
      experiences: (json['experiences'] as List<dynamic>?)
              ?.map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      education: (json['education'] as List<dynamic>?)
              ?.map((e) => EducationEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }
}

class WorkExperience {
  final String title;
  final String company;
  final String location;
  final String startDate;
  final String endDate;
  final List<String> highlights;

  const WorkExperience({
    required this.title,
    required this.company,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.highlights = const [],
  });

  WorkExperience copyWith({
    String? title,
    String? company,
    String? location,
    String? startDate,
    String? endDate,
    List<String>? highlights,
  }) {
    return WorkExperience(
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      highlights: highlights ?? this.highlights,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'company': company,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'highlights': highlights,
    };
  }

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      title: json['title'] as String? ?? '',
      company: json['company'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      highlights: (json['highlights'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }
}

class EducationEntry {
  final String degree;
  final String institution;
  final String year;
  final String attestationStatus;

  const EducationEntry({
    required this.degree,
    required this.institution,
    required this.year,
    required this.attestationStatus,
  });

  EducationEntry copyWith({
    String? degree,
    String? institution,
    String? year,
    String? attestationStatus,
  }) {
    return EducationEntry(
      degree: degree ?? this.degree,
      institution: institution ?? this.institution,
      year: year ?? this.year,
      attestationStatus: attestationStatus ?? this.attestationStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institution': institution,
      'year': year,
      'attestationStatus': attestationStatus,
    };
  }

  factory EducationEntry.fromJson(Map<String, dynamic> json) {
    return EducationEntry(
      degree: json['degree'] as String? ?? '',
      institution: json['institution'] as String? ?? '',
      year: json['year'] as String? ?? '',
      attestationStatus: json['attestationStatus'] as String? ?? '',
    );
  }
}
