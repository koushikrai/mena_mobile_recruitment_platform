import 'dart:io';
import '../domain/cv_parser_repository.dart';
import '../domain/parsed_cv_entity.dart';

class CVParserRepositoryImpl implements CVParserRepository {
  @override
  Future<ParsedCV> uploadCV(File file) async {
    await Future.delayed(const Duration(seconds: 2));
    return const ParsedCV(
      fullName: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+971501234567',
      nationality: 'Indian',
      residentCountry: 'United Arab Emirates',
      targetTitle: 'Senior Flutter Developer',
      totalExperience: 5.5,
      gccExperience: 2.0,
      experiences: [
        WorkExperience(
          title: 'Mobile Developer',
          company: 'Tech Corp',
          location: 'Dubai, UAE',
          startDate: '2021',
          endDate: 'Present',
          highlights: ['Built amazing apps'],
        ),
      ],
      education: [
        EducationEntry(
          degree: 'B.Sc. Computer Science',
          institution: 'University of Technology',
          year: '2019',
          attestationStatus: 'Attested by MOFA',
        ),
      ],
      skills: ['Flutter', 'Dart', 'Riverpod'],
    );
  }

  @override
  Future<void> saveParsedCV(ParsedCV cv) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
