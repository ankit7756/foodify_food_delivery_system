import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/usecases/register_usecase.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/entities/user_entity.dart';
import 'package:foodify_food_delivery_system/features/auth/data/models/auth_api_model.dart';
import 'package:foodify_food_delivery_system/core/error/faliures.dart';

// Generate mock class
@GenerateMocks([AuthRepository])
import 'register_usecase_test.mocks.dart';

void main() {
  late RegisterUseCase registerUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    registerUseCase = RegisterUseCase(mockAuthRepository);
  });

  group('RegisterUseCase Tests', () {
    final testUser = UserEntity(
      username: 'johndoe',
      email: 'john@example.com',
      password: 'password123',
      fullName: 'John Doe',
      phone: '9876543210',
    );

    final testAuthApiModel = AuthApiModel(
      message: 'Registration successful',
      token: 'new_user_token',
      id: 'new_user_id',
      username: 'johndoe',
      email: 'john@example.com',
      fullName: 'John Doe',
      phone: '9876543210',
    );

    test(
      'should return success message when registration is successful',
      () async {
        // Arrange
        when(
          mockAuthRepository.registerApi(any),
        ).thenAnswer((_) async => testAuthApiModel);

        // Act
        final result = await registerUseCase.call(testUser);

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should return success message'), (
          message,
        ) {
          expect(message, 'Registration successful');
        });
        verify(mockAuthRepository.registerApi(testUser)).called(1);
      },
    );

    test('should return ServerFailure when registration fails', () async {
      // Arrange
      when(
        mockAuthRepository.registerApi(any),
      ).thenThrow(Exception('Email already exists'));

      // Act
      final result = await registerUseCase.call(testUser);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, contains('Email already exists'));
      }, (message) => fail('Should return ServerFailure'));
    });

    test('should call repository with correct UserEntity', () async {
      // Arrange
      when(
        mockAuthRepository.registerApi(any),
      ).thenAnswer((_) async => testAuthApiModel);

      // Act
      await registerUseCase.call(testUser);

      // Assert
      final captured =
          verify(mockAuthRepository.registerApi(captureAny)).captured.single
              as UserEntity;
      expect(captured.username, testUser.username);
      expect(captured.email, testUser.email);
      expect(captured.fullName, testUser.fullName);
      expect(captured.phone, testUser.phone);
    });

    test('should handle network error during registration', () async {
      // Arrange
      when(
        mockAuthRepository.registerApi(any),
      ).thenThrow(Exception('Network connection failed'));

      // Act
      final result = await registerUseCase.call(testUser);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, contains('Network connection failed'));
      }, (_) => fail('Should return failure'));
    });

    test('should return message from API response', () async {
      // Arrange
      final customMessage = AuthApiModel(
        message: 'User created successfully',
        token: 'token123',
      );
      when(
        mockAuthRepository.registerApi(any),
      ).thenAnswer((_) async => customMessage);

      // Act
      final result = await registerUseCase.call(testUser);

      // Assert
      result.fold((failure) => fail('Should succeed'), (message) {
        expect(message, 'User created successfully');
      });
    });
  });
}
