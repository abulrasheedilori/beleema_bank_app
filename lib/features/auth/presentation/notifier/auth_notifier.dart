import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/provider/login_usecase_provider.dart';
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

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final useCase = ref.read(loginUseCaseProvider);
  return AuthNotifier(useCase);
});
