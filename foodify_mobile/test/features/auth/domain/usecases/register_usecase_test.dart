import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodify_food_delivery_system/core/error/faliures.dart';
import 'package:foodify_food_delivery_system/features/auth/data/models/auth_api_model.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/entities/user_entity.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/usecases/register_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late RegisterUseCase registerUseCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    registerUseCase = RegisterUseCase(mockRepository);
  });

  final tUser = UserEntity(
    username: 'testuser',
    email: 'test@example.com',
    password: 'password123',
    fullName: 'Test User',
    phone: '9800000000',
  );

  final tAuthApiModel = AuthApiModel(
    message: 'User registered successfully',
    token: null,
    email: null,
    username: null,
    fullName: null,
    phone: null,
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

  group('RegisterUseCase', () {
    test('should return success message when registration succeeds', () async {
      when(
        () => mockRepository.registerApi(any()),
      ).thenAnswer((_) async => tAuthApiModel);

      final result = await registerUseCase(tUser);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected success'),
        (message) => expect(message, 'User registered successfully'),
      );
    });

    test('should return ServerFailure when repository throws', () async {
      when(
        () => mockRepository.registerApi(any()),
      ).thenThrow(Exception('Email already exists'));

      final result = await registerUseCase(tUser);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('should call repository with correct user data', () async {
      when(
        () => mockRepository.registerApi(any()),
      ).thenAnswer((_) async => tAuthApiModel);

      await registerUseCase(tUser);

      verify(() => mockRepository.registerApi(any())).called(1);
    });
  });
}
