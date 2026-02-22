import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodify_food_delivery_system/core/error/faliures.dart';
import 'package:foodify_food_delivery_system/features/home/domain/entities/restaurant_entity.dart';
import 'package:foodify_food_delivery_system/features/home/domain/repositories/home_repository.dart';
import 'package:foodify_food_delivery_system/features/home/domain/usecases/get_restaurants_usecase.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockRepository;
  late GetRestaurantsUseCase useCase;

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = GetRestaurantsUseCase(mockRepository);
  });

  final tRestaurants = [
    const RestaurantEntity(
      id: '1',
      name: 'Test Restaurant',
      image: 'http://image.com/1.jpg',
      description: 'A test restaurant',
      rating: 4.5,
      deliveryTime: '30 min',
      deliveryFee: 50,
      categories: ['Pizza', 'Burger'],
      isOpen: true,
      address: 'Kathmandu',
      phone: '9800000000',
    ),
  ];

  group('GetRestaurantsUseCase', () {
    test('should return list of restaurants on success', () async {
      when(
        () => mockRepository.getAllRestaurants(),
      ).thenAnswer((_) async => Right(tRestaurants));

      final result = await useCase();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected success'),
        (restaurants) => expect(restaurants, tRestaurants),
      );
      verify(() => mockRepository.getAllRestaurants()).called(1);
    });

    test('should return ServerFailure when repository fails', () async {
      when(
        () => mockRepository.getAllRestaurants(),
      ).thenAnswer((_) async => Left(ServerFailure('Network error')));

      final result = await useCase();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('should call repository getAllRestaurants exactly once', () async {
      when(
        () => mockRepository.getAllRestaurants(),
      ).thenAnswer((_) async => Right(tRestaurants));

      await useCase();

      verify(() => mockRepository.getAllRestaurants()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
