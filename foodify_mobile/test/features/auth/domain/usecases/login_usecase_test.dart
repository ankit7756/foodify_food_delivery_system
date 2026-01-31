import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:foodify_food_delivery_system/features/auth/data/models/auth_api_model.dart';
import 'package:foodify_food_delivery_system/core/error/faliures.dart';

// Generate mock class
@GenerateMocks([AuthRepository])
import 'login_usecase_test.mocks.dart';

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  group('LoginUseCase Tests', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    final testAuthApiModel = AuthApiModel(
      message: 'Login successful',
      token: 'test_token_123',
      id: 'user_id_123',
      username: 'testuser',
      email: testEmail,
      fullName: 'Test User',
      phone: '9876543210',
    );

    test('should return UserEntity when login is successful', () async {
      // Arrange
      when(
        mockAuthRepository.loginApi(any, any),
      ).thenAnswer((_) async => testAuthApiModel);

      // Act
      final result = await loginUseCase.call(testEmail, testPassword);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should return UserEntity'), (user) {
        expect(user.email, testEmail);
        expect(user.username, 'testuser');
        expect(user.fullName, 'Test User');
        expect(user.phone, '9876543210');
        expect(user.password, ''); // Password should be empty for security
      });
      verify(mockAuthRepository.loginApi(testEmail, testPassword)).called(1);
    });

    test('should return ServerFailure when login fails', () async {
      // Arrange
      when(
        mockAuthRepository.loginApi(any, any),
      ).thenThrow(Exception('Invalid credentials'));

      // Act
      final result = await loginUseCase.call(testEmail, testPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, contains('Invalid credentials'));
      }, (user) => fail('Should return ServerFailure'));
    });

    test('should call repository with correct parameters', () async {
      // Arrange
      when(
        mockAuthRepository.loginApi(any, any),
      ).thenAnswer((_) async => testAuthApiModel);

      // Act
      await loginUseCase.call(testEmail, testPassword);

      // Assert
      verify(mockAuthRepository.loginApi(testEmail, testPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should handle null token from API response', () async {
      // Arrange
      final modelWithoutToken = AuthApiModel(
        message: 'Login successful',
        token: null,
        username: 'testuser',
        email: testEmail,
        fullName: 'Test User',
        phone: '9876543210',
      );

      when(
        mockAuthRepository.loginApi(any, any),
      ).thenAnswer((_) async => modelWithoutToken);

      // Act
      final result = await loginUseCase.call(testEmail, testPassword);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should succeed even without token'), (
        user,
      ) {
        expect(user.email, testEmail);
        expect(user.username, 'testuser');
      });
    });

    test('should return failure when network error occurs', () async {
      // Arrange
      when(
        mockAuthRepository.loginApi(any, any),
      ).thenThrow(Exception('Network error'));

      // Act
      final result = await loginUseCase.call(testEmail, testPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, contains('Network error'));
      }, (_) => fail('Should return failure'));
    });
  });
}
