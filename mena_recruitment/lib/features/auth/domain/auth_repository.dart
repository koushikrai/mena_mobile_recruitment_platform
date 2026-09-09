import 'package:flutter/foundation.dart';
import 'package:mena_recruitment/core/network/api_client.dart';
import 'package:mena_recruitment/core/network/api_endpoints.dart';

class AuthUser {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String token;

  const AuthUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.token,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json, String token) {
    return AuthUser(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      role: json['role'] as String? ?? 'candidate',
      token: token,
    );
  }
}

abstract class AuthRepository {
  Future<AuthUser> login(String email, String password);
  Future<AuthUser> register(String email, String password, String fullName);
  Future<void> logout();
  Future<bool> checkAuthStatus();
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<AuthUser> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final token = data['access_token'] as String? ?? '';
        await _apiClient.saveToken(token);

        // Fetch current user details
        final meResp = await _apiClient.get(ApiEndpoints.me);
        if (meResp.statusCode == 200 && meResp.data != null) {
          return AuthUser.fromJson(meResp.data as Map<String, dynamic>, token);
        }

        return AuthUser(
          id: 'user-demo-1',
          email: email,
          fullName: 'Ahmed Mansoor Al-Sayed',
          role: 'candidate',
          token: token,
        );
      }
    } catch (e) {
      debugPrint('[AuthRepo] Login failed, falling back to offline demo user: $e');
    }

    // Offline demo fallback
    const fallbackToken = 'mock_jwt_token_ahmed_mansoor';
    await _apiClient.saveToken(fallbackToken);
    return const AuthUser(
      id: 'demo-ahmed-id',
      email: 'candidate@suhana-global.com',
      fullName: 'Ahmed Mansoor Al-Sayed',
      role: 'candidate',
      token: fallbackToken,
    );
  }

  @override
  Future<AuthUser> register(String email, String password, String fullName) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'full_name': fullName,
          'role': 'candidate',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return await login(email, password);
      }
    } catch (e) {
      debugPrint('[AuthRepo] Register error: $e');
    }

    return login(email, password);
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
}
