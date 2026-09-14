import 'package:dio/dio.dart';
import 'package:mena_recruitment/core/network/api_client.dart';
import 'package:mena_recruitment/core/network/api_endpoints.dart';

class AuthUser {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String? phoneCountryCode;
  final String? phoneNumber;
  final String? avatarUrl;
  final String token;

  const AuthUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.phoneCountryCode,
    this.phoneNumber,
    this.avatarUrl,
    required this.token,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json, String token) {
    return AuthUser(
      id: json['id']?.toString() ?? json['user_id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String? ?? json['fullName'] as String? ?? '',
      role: json['role'] as String? ?? 'candidate',
      phoneCountryCode: json['phone_country_code'] as String? ?? '+966',
      phoneNumber: json['phone_number'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      token: token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role,
      'phone_country_code': phoneCountryCode,
      'phone_number': phoneNumber,
      'avatar_url': avatarUrl,
      'token': token,
    };
  }
}

class AuthException implements Exception {
  final String message;
  final bool isNetworkError;

  const AuthException(this.message, {this.isNetworkError = false});

  @override
  String toString() => message;
}

abstract class AuthRepository {
  Future<AuthUser> login(String email, String password);
  Future<AuthUser> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneCountryCode,
    String? phoneNumber,
    String role = 'candidate',
  });
  Future<AuthUser> loginDemo();
  Future<void> logout();
  Future<bool> checkAuthStatus();
  Future<AuthUser?> getCurrentUser();
  Future<bool> pingBackend();
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient = ApiClient();

  String _extractError(dynamic e) {
    if (e is DioException) {
      if (e.response?.data is Map) {
        final detail = e.response!.data['detail'];
        if (detail is String) return detail;
        if (detail is List && detail.isNotEmpty) {
          final first = detail.first;
          if (first is Map && first.containsKey('msg')) {
            return first['msg'].toString();
          }
        }
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return 'Backend server unreachable. Make sure the API server is running on http://127.0.0.1:8000.';
      }
      if (e.response?.statusCode == 401) {
        return 'Incorrect email or password. Please verify your credentials.';
      }
      if (e.response?.statusCode == 400) {
        return 'Invalid authentication request. User may already exist.';
      }
      return e.message ?? 'Network communication error.';
    }
    return e.toString();
  }

  @override
  Future<AuthUser> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'email': email.trim().toLowerCase(),
          'password': password.trim(),
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final token = data['access_token'] as String? ?? '';
        await _apiClient.saveToken(token);

        // Fetch authenticated user details from /me
        try {
          final meResp = await _apiClient.get(ApiEndpoints.me);
          if (meResp.statusCode == 200 && meResp.data != null) {
            return AuthUser.fromJson(meResp.data as Map<String, dynamic>, token);
          }
        } catch (_) {
          // Fallback to token response fields
        }

        return AuthUser(
          id: data['user_id']?.toString() ?? 'live-user-id',
          email: data['email'] as String? ?? email,
          fullName: data['full_name'] as String? ?? 'Verified Candidate',
          role: data['role'] as String? ?? 'candidate',
          token: token,
        );
      }
      throw const AuthException('Invalid response from server.');
    } on DioException catch (e) {
      final msg = _extractError(e);
      final isNet = e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout;
      throw AuthException(msg, isNetworkError: isNet);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(e.toString());
    }
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneCountryCode,
    String? phoneNumber,
    String role = 'candidate',
  }) async {
    try {
      final payload = <String, dynamic>{
        'email': email.trim().toLowerCase(),
        'password': password.trim(),
        'full_name': fullName.trim(),
        'role': role,
        'phone_country_code': phoneCountryCode ?? '+966',
        'preferred_language': 'en',
      };
      if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
        payload['phone_number'] = phoneNumber.trim();
      }

      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: payload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          final token = data['access_token'] as String? ?? '';
          if (token.isNotEmpty) {
            await _apiClient.saveToken(token);
            return AuthUser.fromJson(data, token);
          }
        }
        return await login(email, password);
      }
      throw const AuthException('Registration failed. Please check your details.');
    } on DioException catch (e) {
      final msg = _extractError(e);
      final isNet = e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout;
      throw AuthException(msg, isNetworkError: isNet);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(e.toString());
    }
  }

  @override
  Future<AuthUser> loginDemo() async {
    const fallbackToken = 'mock_jwt_token_candidate_gcc';
    await _apiClient.saveToken(fallbackToken);
    return const AuthUser(
      id: '2baf90ea-33dd-4482-863c-35521c68176a',
      email: 'candidate@suhana-global.com',
      fullName: 'Candidate',
      role: 'candidate',
      phoneCountryCode: '+966',
      phoneNumber: '',
      token: fallbackToken,
    );
  }

  @override
  Future<void> logout() async {
    await _apiClient.clearToken();
  }

  @override
  Future<bool> checkAuthStatus() async {
    final token = await _apiClient.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    final token = await _apiClient.getToken();
    if (token == null || token.isEmpty) return null;

    try {
      final meResp = await _apiClient.get(ApiEndpoints.me);
      if (meResp.statusCode == 200 && meResp.data != null) {
        return AuthUser.fromJson(meResp.data as Map<String, dynamic>, token);
      }
    } catch (_) {
      // If server unreachable but token exists
    }

    return AuthUser(
      id: 'stored-session-user',
      email: 'candidate@suhana-global.com',
      fullName: 'Candidate',
      role: 'candidate',
      token: token,
    );
  }

  @override
  Future<bool> pingBackend() async {
    try {
      final res = await _apiClient.get('/health');
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
