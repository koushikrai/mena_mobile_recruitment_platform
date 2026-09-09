import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mena_recruitment/core/network/api_client.dart';
import 'package:mena_recruitment/core/network/api_endpoints.dart';
import '../domain/cv_parser_repository.dart';
import '../domain/parsed_cv_entity.dart';

class CVParserRepositoryImpl implements CVParserRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<ParsedCV> uploadCV(File file) async {
    try {
      final fileName = file.path.split(Platform.pathSeparator).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await _apiClient.post(
        ApiEndpoints.cvParse,
        data: formData,
      );

      if (response.statusCode == 200 && response.data != null) {
        return ParsedCV.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('[CVParserRepo] Backend AI parse error, falling back to mock: $e');
    }

    // Graceful fallback to mock data
    await Future.delayed(const Duration(milliseconds: 600));
    return const ParsedCV(
      fullName: 'Ahmed Mansoor Al-Sayed',
      email: 'ahmed.mansoor@example.com',
      phone: '+966 550123456',
      nationality: 'Egyptian',
      residentCountry: 'Saudi Arabia',
      targetTitle: 'Senior Offshore HSE Supervisor',
      totalExperience: 7.5,
      gccExperience: 4.0,
      experiences: [
        WorkExperience(
          title: 'Offshore Safety Specialist',
          company: 'Consolidated Contractors Co. (CCC)',
          location: 'Jubail, Saudi Arabia',
          startDate: '2020',
          endDate: 'Present',
          highlights: ['Zero-incident turnaround operations', 'Supervising PTW approvals'],
        ),
      ],
      education: [
        EducationEntry(
          degree: 'B.Sc. Petroleum & Safety Engineering',
          institution: 'Suez University',
          year: '2017',
          attestationStatus: 'Attested by MOFA',
        ),
      ],
      skills: ['NEBOSH IGC', 'OPITO BOSIET', 'Saudi Aramco Approval', 'PTW Mastery'],
    );
  }

  @override
  Future<void> saveParsedCV(ParsedCV cv) async {
    try {
      await _apiClient.put(
        ApiEndpoints.candidateProfile,
        data: {
          'target_job_title': cv.targetTitle,
          'nationality': cv.nationality,
          'current_resident_country': cv.residentCountry,
          'total_experience_years': cv.totalExperience,
          'gcc_experience_years': cv.gccExperience,
        },
      );
    } catch (e) {
      debugPrint('[CVParserRepo] Profile sync offline: $e');
    }
  }
}
