import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodify_food_delivery_system/core/error/faliures.dart';
import 'package:foodify_food_delivery_system/features/auth/data/models/auth_api_model.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/entities/user_entity.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase loginUseCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';

  final tAuthApiModel = AuthApiModel(
    token: 'test_token',
    email: tEmail,
    username: 'testuser',
    fullName: 'Test User',
    phone: '9800000000',
    message: 'Login successful',
  );

  group('LoginUseCase', () {
    test('should return UserEntity when login is successful', () async {
      when(
        () => mockRepository.loginApi(any(), any()),
      ).thenAnswer((_) async => tAuthApiModel);

      final result = await loginUseCase(tEmail, tPassword);

      expect(result.isRight(), true);
      result.fold((failure) => fail('Expected success'), (user) {
        expect(user.email, tEmail);
        expect(user.username, 'testuser');
      });
      verify(() => mockRepository.loginApi(tEmail, tPassword)).called(1);
    });

    test(
      'should return ServerFailure when repository throws exception',
      () async {
        when(
          () => mockRepository.loginApi(any(), any()),
        ).thenThrow(Exception('Network error'));

        final result = await loginUseCase(tEmail, tPassword);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Expected failure'),
        );
      },
    );

    test('should call repository with correct email and password', () async {
      when(
        () => mockRepository.loginApi(any(), any()),
      ).thenAnswer((_) async => tAuthApiModel);

      await loginUseCase(tEmail, tPassword);

      verify(() => mockRepository.loginApi(tEmail, tPassword)).called(1);
    });

    test('should return UserEntity with empty password for security', () async {
      when(
        () => mockRepository.loginApi(any(), any()),
      ).thenAnswer((_) async => tAuthApiModel);

      final result = await loginUseCase(tEmail, tPassword);

      result.fold(
        (_) => fail('Expected success'),
        (user) => expect(user.password, ''),
      );
    });
  });
}
