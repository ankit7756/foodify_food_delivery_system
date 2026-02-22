import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodify_food_delivery_system/core/error/faliures.dart';
import 'package:foodify_food_delivery_system/features/home/domain/entities/food_entity.dart';
import 'package:foodify_food_delivery_system/features/home/domain/repositories/home_repository.dart';
import 'package:foodify_food_delivery_system/features/home/domain/usecases/get_popular_foods_usecase.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockRepository;
  late GetPopularFoodsUseCase useCase;

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = GetPopularFoodsUseCase(mockRepository);
  });

  final tFoods = [
    const FoodEntity(
      id: '1',
      restaurantId: 'r1',
      name: 'Margherita Pizza',
      image: 'http://image.com/pizza.jpg',
      description: 'Classic pizza',
      price: 500,
      category: 'Pizza',
      rating: 4.8,
      isAvailable: true,
      isPopular: true,
    ),
  ];

  group('GetPopularFoodsUseCase', () {
    test('should return list of popular foods on success', () async {
      when(
        () => mockRepository.getPopularFoods(),
      ).thenAnswer((_) async => Right(tFoods));

      final result = await useCase();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected success'),
        (foods) => expect(foods, tFoods),
      );
      verify(() => mockRepository.getPopularFoods()).called(1);
    });

    test('should return ServerFailure when repository fails', () async {
      when(
        () => mockRepository.getPopularFoods(),
      ).thenAnswer((_) async => Left(ServerFailure('Network error')));

      final result = await useCase();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('should return empty list when no popular foods exist', () async {
      when(
        () => mockRepository.getPopularFoods(),
      ).thenAnswer((_) async => const Right([]));

      final result = await useCase();

      result.fold(
        (_) => fail('Expected success'),
        (foods) => expect(foods, isEmpty),
      );
    });
  });
}
