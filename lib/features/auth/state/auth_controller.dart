import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:loan_management_system/core/services/auth_storage_service.dart';

final authStorageProvider = Provider((ref) => AuthStorageService());

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(ref.read(authStorageProvider));
  },
);

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({bool? isLoading, String? error, bool? isAuthenticated}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._storage) : super(const AuthState());

  final AuthStorageService _storage;

  Future<void> checkAuthStatus() async {
    final isLoggedIn = await _storage.isLoggedIn();
    if (isLoggedIn) {
      state = state.copyWith(isAuthenticated: true);
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: integrate API call
      await Future.delayed(const Duration(seconds: 1));

      // fake validation for demo
      if (email.toLowerCase() != "chathuriranasinghe2001@gmail.com" ||
          password != "Chathu@2001") {
        state = state.copyWith(
          isLoading: false,
          error: "Invalid email or password",
        );
        return false;
      }

      // TODO: integrate API call - save real tokens from API response
      await _storage.saveTokens(
        accessToken: 'test_access_token',
        refreshToken: 'test_refresh_token',
        userId: '1',
        userEmail: email,
      );

      state = state.copyWith(
        isLoading: false,
        error: null,
        isAuthenticated: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Something went wrong");
      return false;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 1));

      // TODO: integrate real API call here
      if (!email.contains('@')) {
        state = state.copyWith(
          isLoading: false,
          error: "Enter a valid email address",
        );
        return false;
      }

      state = state.copyWith(isLoading: false, error: null);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to send reset instructions",
      );
      return false;
    }
  }

  Future<bool> resetPassword({required String newPassword}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 1));

      // TODO: connect backend API
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to reset password",
      );
      return false;
    }
  }

  Future<void> signOut() async {
    await _storage.clearAll();
    state = state.copyWith(isAuthenticated: false);
  }
}
