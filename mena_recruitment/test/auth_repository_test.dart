import 'package:flutter_test/flutter_test.dart';
import 'package:mena_recruitment/features/auth/domain/auth_repository.dart';
import 'package:mena_recruitment/features/auth/providers/auth_provider.dart';

class MockAuthRepository implements AuthRepository {
  bool failNextLogin = false;
  bool isOnline = true;

  @override
  Future<AuthUser> login(String email, String password) async {
    if (failNextLogin) {
      throw const AuthException('Invalid email or password.');
    }
    return const AuthUser(
      id: 'mock-user-123',
      email: 'candidate@suhana-global.com',
      fullName: 'Ahmed Mansoor Al-Farooq',
      role: 'candidate',
      phoneCountryCode: '+966',
      phoneNumber: '551234567',
      avatarUrl: null,
      token: 'mock_jwt_token_xyz',
    );
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
    return AuthUser(
      id: 'mock-new-id',
      email: email,
      fullName: fullName,
      role: role,
      phoneCountryCode: phoneCountryCode,
      phoneNumber: phoneNumber,
      token: 'mock_new_jwt_token',
    );
  }

  @override
  Future<AuthUser> loginDemo() async {
    return const AuthUser(
      id: 'demo-cand-001',
      email: 'candidate@suhana-global.com',
      fullName: 'Ahmed Mansoor Al-Farooq',
      role: 'candidate',
      phoneCountryCode: '+966',
      phoneNumber: '551234567',
      token: 'demo_token_suhana_mena',
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<bool> checkAuthStatus() async => false;

  @override
  Future<AuthUser?> getCurrentUser() async => null;

  @override
  Future<bool> pingBackend() async => isOnline;
}

void main() {
  group('AuthUser model serialization', () {
    test('AuthUser fromJson maps backend token and user data', () {
      final json = {
        'id': 'user-77',
        'email': 'ahmed@test.com',
        'full_name': 'Ahmed Tester',
        'role': 'candidate',
        'phone_country_code': '+971',
        'phone_number': '501234567',
        'avatar_url': 'https://example.com/avatar.jpg',
      };

      final user = AuthUser.fromJson(json, 'token_abc');
      expect(user.id, 'user-77');
      expect(user.email, 'ahmed@test.com');
      expect(user.fullName, 'Ahmed Tester');
      expect(user.role, 'candidate');
      expect(user.phoneCountryCode, '+971');
      expect(user.phoneNumber, '501234567');
      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
      expect(user.token, 'token_abc');
    });

    test('AuthUser toJson serializes correctly', () {
      const user = AuthUser(
        id: 'u-1',
        email: 'test@gcc.com',
        fullName: 'GCC Engineer',
        role: 'candidate',
        token: 'token_123',
      );
      final json = user.toJson();
      expect(json['id'], 'u-1');
      expect(json['email'], 'test@gcc.com');
      expect(json['token'], 'token_123');
    });
  });

  group('AuthState and AuthNotifier flow', () {
    test('AuthState initial state is unauthenticated', () {
      const state = AuthState();
      expect(state.isAuthenticated, false);
      expect(state.isLoading, false);
      expect(state.user, isNull);
    });

    test('AuthNotifier handles successful login and logout', () async {
      final mockRepo = MockAuthRepository();
      final notifier = AuthNotifier(mockRepo);

      expect(notifier.state.isAuthenticated, false);

      final success = await notifier.login('candidate@suhana-global.com', 'Secret123!');
      expect(success, true);
      expect(notifier.state.isAuthenticated, true);
      expect(notifier.state.user?.email, 'candidate@suhana-global.com');
      expect(notifier.state.isDemoMode, false);

      await notifier.logout();
      expect(notifier.state.isAuthenticated, false);
      expect(notifier.state.user, isNull);
    });

    test('AuthNotifier handles failed login with error message', () async {
      final mockRepo = MockAuthRepository()..failNextLogin = true;
      final notifier = AuthNotifier(mockRepo);

      final success = await notifier.login('wrong@email.com', 'wrongpassword');
      expect(success, false);
      expect(notifier.state.isAuthenticated, false);
      expect(notifier.state.errorMessage, contains('Invalid email or password'));

      notifier.clearError();
      expect(notifier.state.errorMessage, isNull);
    });

    test('AuthNotifier handles demo login flag', () async {
      final mockRepo = MockAuthRepository();
      final notifier = AuthNotifier(mockRepo);

      await notifier.loginDemo();
      expect(notifier.state.isAuthenticated, true);
      expect(notifier.state.isDemoMode, true);
    });
  });
}
