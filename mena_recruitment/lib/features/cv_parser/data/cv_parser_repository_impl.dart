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

    // Graceful fallback when backend is unreachable
    await Future.delayed(const Duration(milliseconds: 300));
    final rawName = file.path.split(Platform.pathSeparator).last.split('.').first;
    final cleanName = rawName.replaceAll(RegExp(r'[_.-]+'), ' ').trim();
    return ParsedCV(
      fullName: cleanName.isNotEmpty ? cleanName : 'Candidate Profile',
      email: '',
      phone: '',
      nationality: '',
      residentCountry: '',
      targetTitle: '',
      totalExperience: 0.0,
      gccExperience: 0.0,
      experiences: const [],
      education: const [],
      skills: const [],
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
