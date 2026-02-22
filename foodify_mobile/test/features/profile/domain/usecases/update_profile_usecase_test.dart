import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodify_food_delivery_system/core/error/faliures.dart';
import 'package:foodify_food_delivery_system/features/profile/domain/entities/user_profile_entity.dart';
import 'package:foodify_food_delivery_system/features/profile/data/repositories/profile_repository.dart';
import 'package:foodify_food_delivery_system/features/profile/domain/usecases/update_profile_usecase.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockRepository;
  late UpdateProfileUseCase useCase;

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = UpdateProfileUseCase(mockRepository);
  });

  const tProfile = UserProfileEntity(
    id: 'u1',
    fullName: 'Test User',
    username: 'testuser',
    email: 'test@example.com',
    phone: '9800000000',
    role: 'user',
  );

  group('UpdateProfileUseCase', () {
    test('should return updated profile on success', () async {
      when(
        () => mockRepository.updateProfile(
          token: any(named: 'token'),
          fullName: any(named: 'fullName'),
          username: any(named: 'username'),
          phone: any(named: 'phone'),
          profileImage: any(named: 'profileImage'),
        ),
      ).thenAnswer((_) async => const Right(tProfile));

      final result = await useCase(
        token: 'test_token',
        fullName: 'Test User',
        username: 'testuser',
        phone: '9800000000',
      );

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected success'),
        (profile) => expect(profile.fullName, 'Test User'),
      );
    });

    test('should return ServerFailure when update fails', () async {
      when(
        () => mockRepository.updateProfile(
          token: any(named: 'token'),
          fullName: any(named: 'fullName'),
          username: any(named: 'username'),
          phone: any(named: 'phone'),
          profileImage: any(named: 'profileImage'),
        ),
      ).thenAnswer((_) async => Left(ServerFailure('Update failed')));

      final result = await useCase(
        token: 'test_token',
        fullName: 'Test User',
        username: 'testuser',
        phone: '9800000000',
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Update failed'),
        (_) => fail('Expected failure'),
      );
    });

    test('should call repository with correct parameters', () async {
      when(
        () => mockRepository.updateProfile(
          token: any(named: 'token'),
          fullName: any(named: 'fullName'),
          username: any(named: 'username'),
          phone: any(named: 'phone'),
          profileImage: any(named: 'profileImage'),
        ),
      ).thenAnswer((_) async => const Right(tProfile));

      await useCase(
        token: 'my_token',
        fullName: 'New Name',
        username: 'newuser',
        phone: '9811111111',
      );

      verify(
        () => mockRepository.updateProfile(
          token: 'my_token',
          fullName: 'New Name',
          username: 'newuser',
          phone: '9811111111',
          profileImage: null,
        ),
      ).called(1);
    });
  });
}
