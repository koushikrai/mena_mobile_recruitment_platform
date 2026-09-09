import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/auth/domain/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthUser?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<AuthUser?>> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AsyncValue.data(null)) {
    _init();
  }

  Future<void> _init() async {
    final isLoggedIn = await _repo.checkAuthStatus();
    if (isLoggedIn) {
      // Auto-restore demo user session
      state = const AsyncValue.data(
        AuthUser(
          id: 'demo-ahmed-id',
          email: 'candidate@suhana-global.com',
          fullName: 'Ahmed Mansoor Al-Sayed',
          role: 'candidate',
          token: 'restored_token',
        ),
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.login(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(String email, String password, String fullName) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.register(email, password, fullName);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AsyncValue.data(null);
  }
}
