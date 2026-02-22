import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/user_session_service.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/auth_providers.dart';
import '../state/auth_state.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);

class AuthViewModel extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> registerUser(UserEntity user) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final registerUseCase = ref.read(registerUseCaseProvider);
    final result = await registerUseCase(user);

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (message) => state = state.copyWith(
        status: AuthStatus.registered,
        errorMessage: null,
      ),
    );
  }

  Future<void> loginUser(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final loginUseCase = ref.read(loginUseCaseProvider);
    final result = await loginUseCase(email, password);

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) async {
        // Note: LoginUseCase should return token, we need to save it
        // For now, just mark as authenticated
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> logoutUser() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final logoutUseCase = ref.read(logoutUseCaseProvider);
    final result = await logoutUseCase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        errorMessage: null,
      ),
    );
  }

  void resetState() {
    state = const AuthState(status: AuthStatus.initial);
  }
}
