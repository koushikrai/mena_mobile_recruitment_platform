import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/auth/domain/auth_repository.dart';

class AuthState {
  final AuthUser? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isBackendOnline;
  final bool isDemoMode;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isBackendOnline = true,
    this.isDemoMode = false,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    AuthUser? user,
    bool? clearUser,
    bool? isLoading,
    String? errorMessage,
    bool? clearError,
    bool? isBackendOnline,
    bool? isDemoMode,
  }) {
    return AuthState(
      user: clearUser == true ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError == true ? null : (errorMessage ?? this.errorMessage),
      isBackendOnline: isBackendOnline ?? this.isBackendOnline,
      isDemoMode: isDemoMode ?? this.isDemoMode,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AuthState()) {
    _init();
  }

  Future<void> _init() async {
    checkServerHealth();
    final user = await _repo.getCurrentUser();
    if (user != null) {
      state = state.copyWith(user: user);
    }
  }

  Future<bool> checkServerHealth() async {
    final isOnline = await _repo.pingBackend();
    state = state.copyWith(isBackendOnline: isOnline);
    return isOnline;
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repo.login(email, password);
      state = state.copyWith(
        user: user,
        isLoading: false,
        clearError: true,
        isDemoMode: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneCountryCode,
    String? phoneNumber,
    String role = 'candidate',
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repo.register(
        email: email,
        password: password,
        fullName: fullName,
        phoneCountryCode: phoneCountryCode,
        phoneNumber: phoneNumber,
        role: role,
      );
      state = state.copyWith(
        user: user,
        isLoading: false,
        clearError: true,
        isDemoMode: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<void> loginDemo() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final user = await _repo.loginDemo();
    state = state.copyWith(
      user: user,
      isLoading: false,
      clearError: true,
      isDemoMode: true,
    );
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState(isBackendOnline: true);
  }
}
