import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodify_food_delivery_system/core/error/faliures.dart';
import 'package:foodify_food_delivery_system/features/auth/data/models/auth_api_model.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/entities/user_entity.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/usecases/logout_usecase.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/usecases/register_usecase.dart';
import 'package:foodify_food_delivery_system/features/auth/presentation/providers/auth_providers.dart';
import 'package:foodify_food_delivery_system/features/auth/presentation/state/auth_state.dart';
import 'package:foodify_food_delivery_system/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late ProviderContainer container;

  final tAuthApiModel = AuthApiModel(
    token: 'test_token',
    email: 'test@example.com',
    username: 'testuser',
    fullName: 'Test User',
    phone: '9800000000',
    message: 'Success',
  );

  final tRegisterModel = AuthApiModel(
    message: 'Registered successfully',
    token: null,
    email: null,
    username: null,
    fullName: null,
    phone: null,
  );

  final tUser = UserEntity(
    username: 'testuser',
    email: 'test@example.com',
    password: 'password123',
    fullName: 'Test User',
    phone: '9800000000',
  );

  setUpAll(() {
    registerFallbackValue(
      UserEntity(
        username: 'fallback',
        email: 'fallback@example.com',
        password: 'fallback',
        fullName: 'Fallback User',
        phone: '9800000000',
      ),
    );
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepository = MockAuthRepository();

    container = ProviderContainer(
      overrides: [
        loginUseCaseProvider.overrideWithValue(LoginUseCase(mockRepository)),
        registerUseCaseProvider.overrideWithValue(
          RegisterUseCase(mockRepository),
        ),
        logoutUseCaseProvider.overrideWithValue(LogoutUseCase()),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('AuthViewModel - initial state', () {
    test('should have initial status on creation', () {
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.initial);
      expect(state.user, isNull);
      expect(state.errorMessage, isNull);
    });
  });

  group('AuthViewModel - loginUser', () {
    test('should emit authenticated state on successful login', () async {
      when(
        () => mockRepository.loginApi(any(), any()),
      ).thenAnswer((_) async => tAuthApiModel);

      await container
          .read(authViewModelProvider.notifier)
          .loginUser('test@example.com', 'password123');

      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user, isNotNull);
      expect(state.errorMessage, isNull);
    });

    test('should emit error state on failed login', () async {
      when(
        () => mockRepository.loginApi(any(), any()),
      ).thenThrow(Exception('Invalid credentials'));

      await container
          .read(authViewModelProvider.notifier)
          .loginUser('test@example.com', 'wrongpassword');

      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, isNotNull);
    });

    test('should emit loading state during login', () async {
      when(
        () => mockRepository.loginApi(any(), any()),
      ).thenAnswer((_) async => tAuthApiModel);

      final future = container
          .read(authViewModelProvider.notifier)
          .loginUser('test@example.com', 'password123');

      // State should be loading immediately after call
      // (checking synchronously before await)
      final stateWhileLoading = container.read(authViewModelProvider);
      expect(stateWhileLoading.status, AuthStatus.loading);

      await future;
    });

    test('should store user data on successful login', () async {
      when(
        () => mockRepository.loginApi(any(), any()),
      ).thenAnswer((_) async => tAuthApiModel);

      await container
          .read(authViewModelProvider.notifier)
          .loginUser('test@example.com', 'password123');

      final state = container.read(authViewModelProvider);
      expect(state.user?.email, 'test@example.com');
      expect(state.user?.username, 'testuser');
    });
  });

  group('AuthViewModel - registerUser', () {
    test('should emit registered state on successful registration', () async {
      when(
        () => mockRepository.registerApi(any()),
      ).thenAnswer((_) async => tRegisterModel);

      await container.read(authViewModelProvider.notifier).registerUser(tUser);

      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.registered);
      expect(state.errorMessage, isNull);
    });

    test('should emit error state on failed registration', () async {
      when(
        () => mockRepository.registerApi(any()),
      ).thenThrow(Exception('Email already exists'));

      await container.read(authViewModelProvider.notifier).registerUser(tUser);

      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, isNotNull);
    });
  });

  group('AuthViewModel - logoutUser', () {
    test('should emit unauthenticated state on logout', () async {
      when(
        () => mockRepository.loginApi(any(), any()),
      ).thenAnswer((_) async => tAuthApiModel);

      // Login first
      await container
          .read(authViewModelProvider.notifier)
          .loginUser('test@example.com', 'password123');

      // Then logout
      await container.read(authViewModelProvider.notifier).logoutUser();

      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
    });
  });

  group('AuthViewModel - resetState', () {
    test('should reset state to initial', () async {
      when(
        () => mockRepository.loginApi(any(), any()),
      ).thenThrow(Exception('Error'));

      await container
          .read(authViewModelProvider.notifier)
          .loginUser('test@example.com', 'password123');

      expect(container.read(authViewModelProvider).status, AuthStatus.error);

      container.read(authViewModelProvider.notifier).resetState();

      expect(container.read(authViewModelProvider).status, AuthStatus.initial);
    });
  });

  group('AuthState', () {
    test('should have correct initial values', () {
      const state = AuthState();
      expect(state.status, AuthStatus.initial);
      expect(state.user, isNull);
      expect(state.errorMessage, isNull);
    });

    test('copyWith should update status correctly', () {
      const state = AuthState();
      final newState = state.copyWith(status: AuthStatus.loading);
      expect(newState.status, AuthStatus.loading);
      expect(newState.user, isNull);
    });

    test('two states with same values should be equal', () {
      const state1 = AuthState(status: AuthStatus.initial);
      const state2 = AuthState(status: AuthStatus.initial);
      expect(state1, state2);
    });
  });
}
