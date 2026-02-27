import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:loan_management_system/core/services/auth_storage_service.dart';
import '../../../core/networking/api_client.dart';
import '../data/auth_repository.dart';
import '../domain/auth_models.dart';

final authStorageProvider = Provider((ref) => AuthStorageService());

final apiClientProvider = Provider((ref) {
  final storage = ref.read(authStorageProvider);
  return ApiClient(storage);
});

final authRepositoryProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AuthRepository(apiClient);
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(
      ref.read(authStorageProvider),
      ref.read(authRepositoryProvider),
    );
  },
);

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final String? username;
  final String? role;
  final List<String>? permissions;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.username,
    this.role,
    this.permissions,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    String? username,
    String? role,
    List<String>? permissions,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      username: username ?? this.username,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._storage, this._repository) : super(const AuthState());

  final AuthStorageService _storage;
  final AuthRepository _repository;

  Future<void> checkAuthStatus() async {
    final isLoggedIn = await _storage.isLoggedIn();
    if (isLoggedIn) {
      state = state.copyWith(isAuthenticated: true);
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = LoginRequest(username: email, password: password);
      final response = await _repository.login(request);

      await _storage.saveTokens(
        accessToken: response.token,
        refreshToken: response.token,
        userId: response.username,
        userEmail: response.email,
      );

      state = state.copyWith(
        isLoading: false,
        error: null,
        isAuthenticated: true,
        username: response.username,
        role: response.role,
        permissions: response.permissions,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );
      await _repository.changePassword(request);
      state = state.copyWith(isLoading: false, error: null);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }



  Future<void> signOut() async {
    await _storage.clearAll();
    state = state.copyWith(isAuthenticated: false);
  }
}
