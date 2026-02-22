import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodify_food_delivery_system/core/error/faliures.dart';
import 'package:foodify_food_delivery_system/features/home/domain/entities/restaurant_entity.dart';
import 'package:foodify_food_delivery_system/features/home/domain/repositories/home_repository.dart';
import 'package:foodify_food_delivery_system/features/home/domain/usecases/get_restaurant_detail_usecase.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockRepository;
  late GetRestaurantDetailUseCase useCase;

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = GetRestaurantDetailUseCase(mockRepository);
  });

  const tRestaurant = RestaurantEntity(
    id: 'r1',
    name: 'Test Restaurant',
    image: 'http://image.com/r.jpg',
    description: 'A test restaurant',
    rating: 4.5,
    deliveryTime: '30 min',
    deliveryFee: 50,
    categories: ['Pizza'],
    isOpen: true,
    address: 'Kathmandu',
    phone: '9800000000',
  );

  group('GetRestaurantDetailUseCase', () {
    test('should return restaurant when found by id', () async {
      when(
        () => mockRepository.getRestaurantById(any()),
      ).thenAnswer((_) async => const Right(tRestaurant));

      final result = await useCase('r1');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected success'),
        (restaurant) => expect(restaurant.id, 'r1'),
      );
    });

    test('should return ServerFailure when restaurant not found', () async {
      when(
        () => mockRepository.getRestaurantById(any()),
      ).thenAnswer((_) async => Left(ServerFailure('Not found')));

      final result = await useCase('invalid_id');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Not found'),
        (_) => fail('Expected failure'),
      );
    });

    test('should pass correct id to repository', () async {
      when(
        () => mockRepository.getRestaurantById(any()),
      ).thenAnswer((_) async => const Right(tRestaurant));

      await useCase('r1');

      verify(() => mockRepository.getRestaurantById('r1')).called(1);
    });
  });
}
