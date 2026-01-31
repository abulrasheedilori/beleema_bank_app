// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../../../core/security/secure_storage.dart';
// import '../../data/auth_repository/auth_repository.dart';
// import '../../data/dto/api_response.dart';
//
// final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
//   return AuthNotifier(AuthRepository());
// });
//
// class AuthState {
//   final bool loading;
//   final String? error;
//   final bool isAuthenticated;
//   final bool hasPinSet;
//
//   const AuthState({
//     this.loading = false,
//     this.error,
//     this.isAuthenticated = false,
//     this.hasPinSet = false,
//   });
//
//   AuthState copyWith({
//     bool? loading,
//     String? error,
//     bool? isAuthenticated,
//     bool? hasPinSet,
//   }) {
//     return AuthState(
//       loading: loading ?? this.loading,
//       error: error,
//       isAuthenticated: isAuthenticated ?? this.isAuthenticated,
//       hasPinSet: hasPinSet ?? this.hasPinSet,
//     );
//   }
// }
//
// class AuthNotifier extends StateNotifier<AuthState> {
//   final AuthRepository _authApi;
//
//   AuthNotifier(this._authApi) : super(const AuthState());
//
//   Future<void> login(String username, String password) async {
//     state = state.copyWith(loading: true, error: null);
//
//     ApiResponse result = await _authApi.login(username, password);
//
//     if (!result.success) {
//       state = state.copyWith(
//         loading: false,
//         error: result.message,
//         isAuthenticated: false,
//       );
//       return;
//     }
//
//     try {
//       await SecureStorage.write('auth_token', result.data.accessToken);
//     } catch (_) {
//       state = state.copyWith(loading: false, error: 'Failed to save session');
//       return;
//     }
//     state = state.copyWith(
//       loading: false,
//       isAuthenticated: true,
//       hasPinSet: result.data.hasPin,
//     );
//   }
// }

// lib/features/auth/presentation/provider/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth_repository/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';

/// Auth state
class AuthState {
  final bool loading;
  final bool isAuthenticated;
  final String? error;
  final bool? hasPinSet;

  AuthState({
    this.loading = false,
    this.isAuthenticated = false,
    this.error,
    this.hasPinSet,
  });

  AuthState copyWith({
    bool? loading,
    bool? isAuthenticated,
    String? error,
    bool? hasPinSet,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error,
      hasPinSet: hasPinSet ?? this.hasPinSet,
    );
  }
}

/// AuthNotifier using LoginUseCase
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase useCase;

  AuthNotifier(this.useCase) : super(AuthState());

  Future<void> login(String username, String password) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final result = await useCase.execute(
        username: username,
        password: password,
      );

      if (result.success && result.data != null) {
        state = state.copyWith(
          loading: false,
          isAuthenticated: true,
          hasPinSet: result.data.hasPin,
        );
      } else {
        state = state.copyWith(
          loading: false,
          error: result.message ?? 'Login failed',
        );
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

/// Riverpod provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = AuthRepository();
  final useCase = LoginUseCase(repository);
  return AuthNotifier(useCase);
});
