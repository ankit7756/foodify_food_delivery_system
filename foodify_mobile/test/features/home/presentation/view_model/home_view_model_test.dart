import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodify_food_delivery_system/core/error/faliures.dart';
import 'package:foodify_food_delivery_system/features/home/domain/entities/food_entity.dart';
import 'package:foodify_food_delivery_system/features/home/domain/entities/restaurant_entity.dart';
import 'package:foodify_food_delivery_system/features/home/domain/repositories/home_repository.dart';
import 'package:foodify_food_delivery_system/features/home/domain/usecases/get_popular_foods_usecase.dart';
import 'package:foodify_food_delivery_system/features/home/domain/usecases/get_restaurants_usecase.dart';
import 'package:foodify_food_delivery_system/features/home/presentation/providers/home_providers.dart';
import 'package:foodify_food_delivery_system/features/home/presentation/state/home_state.dart';
import 'package:foodify_food_delivery_system/features/home/presentation/view_model/home_view_model.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockRepository;
  late ProviderContainer container;

  final tRestaurants = [
    const RestaurantEntity(
      id: '1',
      name: 'Test Restaurant',
      image: 'http://image.com/1.jpg',
      description: 'A test restaurant',
      rating: 4.5,
      deliveryTime: '30 min',
      deliveryFee: 50,
      categories: ['Pizza'],
      isOpen: true,
      address: 'Kathmandu',
      phone: '9800000000',
    ),
  ];

  final tFoods = [
    const FoodEntity(
      id: '1',
      restaurantId: 'r1',
      name: 'Pizza',
      image: 'http://image.com/p.jpg',
      description: 'Classic pizza',
      price: 500,
      category: 'Pizza',
      rating: 4.8,
      isAvailable: true,
      isPopular: true,
    ),
  ];

  setUp(() {
    mockRepository = MockHomeRepository();
    container = ProviderContainer(
      overrides: [
        getRestaurantsUseCaseProvider.overrideWithValue(
          GetRestaurantsUseCase(mockRepository),
        ),
        getPopularFoodsUseCaseProvider.overrideWithValue(
          GetPopularFoodsUseCase(mockRepository),
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('HomeViewModel - initial state', () {
    test('should have initial status on creation', () {
      final state = container.read(homeViewModelProvider);
      expect(state.status, HomeStatus.initial);
      expect(state.restaurants, isEmpty);
      expect(state.popularFoods, isEmpty);
      expect(state.errorMessage, isNull);
    });
  });

  group('HomeViewModel - loadHomeData', () {
    test('should emit loaded state with data on success', () async {
      when(
        () => mockRepository.getAllRestaurants(),
      ).thenAnswer((_) async => Right(tRestaurants));
      when(
        () => mockRepository.getPopularFoods(),
      ).thenAnswer((_) async => Right(tFoods));

      await container.read(homeViewModelProvider.notifier).loadHomeData();

      final state = container.read(homeViewModelProvider);
      expect(state.status, HomeStatus.loaded);
      expect(state.restaurants, tRestaurants);
      expect(state.popularFoods, tFoods);
      expect(state.errorMessage, isNull);
    });

    test('should emit error state when restaurants fail', () async {
      when(
        () => mockRepository.getAllRestaurants(),
      ).thenAnswer((_) async => Left(ServerFailure('Network error')));
      when(
        () => mockRepository.getPopularFoods(),
      ).thenAnswer((_) async => Right(tFoods));

      await container.read(homeViewModelProvider.notifier).loadHomeData();

      final state = container.read(homeViewModelProvider);
      expect(state.status, HomeStatus.error);
      expect(state.errorMessage, 'Network error');
    });

    test('should emit error state when popular foods fail', () async {
      when(
        () => mockRepository.getAllRestaurants(),
      ).thenAnswer((_) async => Right(tRestaurants));
      when(
        () => mockRepository.getPopularFoods(),
      ).thenAnswer((_) async => Left(ServerFailure('Foods error')));

      await container.read(homeViewModelProvider.notifier).loadHomeData();

      final state = container.read(homeViewModelProvider);
      expect(state.status, HomeStatus.error);
      expect(state.errorMessage, 'Foods error');
    });

    test('should emit loading state at start of loadHomeData', () async {
      when(
        () => mockRepository.getAllRestaurants(),
      ).thenAnswer((_) async => Right(tRestaurants));
      when(
        () => mockRepository.getPopularFoods(),
      ).thenAnswer((_) async => Right(tFoods));

      final future = container
          .read(homeViewModelProvider.notifier)
          .loadHomeData();

      final stateWhileLoading = container.read(homeViewModelProvider);
      expect(stateWhileLoading.status, HomeStatus.loading);

      await future;
    });

    test('should have correct restaurant count after loading', () async {
      when(
        () => mockRepository.getAllRestaurants(),
      ).thenAnswer((_) async => Right(tRestaurants));
      when(
        () => mockRepository.getPopularFoods(),
      ).thenAnswer((_) async => Right(tFoods));

      await container.read(homeViewModelProvider.notifier).loadHomeData();

      final state = container.read(homeViewModelProvider);
      expect(state.restaurants.length, 1);
      expect(state.popularFoods.length, 1);
    });

    test('should reset to initial state when resetState is called', () async {
      when(
        () => mockRepository.getAllRestaurants(),
      ).thenAnswer((_) async => Right(tRestaurants));
      when(
        () => mockRepository.getPopularFoods(),
      ).thenAnswer((_) async => Right(tFoods));

      await container.read(homeViewModelProvider.notifier).loadHomeData();
      expect(container.read(homeViewModelProvider).status, HomeStatus.loaded);

      container.read(homeViewModelProvider.notifier).resetState();

      expect(container.read(homeViewModelProvider).status, HomeStatus.initial);
    });
  });

  group('HomeState', () {
    test('should have correct initial values', () {
      const state = HomeState();
      expect(state.status, HomeStatus.initial);
      expect(state.restaurants, isEmpty);
      expect(state.popularFoods, isEmpty);
      expect(state.errorMessage, isNull);
    });

    test('copyWith should update status correctly', () {
      const state = HomeState();
      final newState = state.copyWith(status: HomeStatus.loading);
      expect(newState.status, HomeStatus.loading);
      expect(newState.restaurants, isEmpty);
    });

    test('two states with same values should be equal', () {
      const state1 = HomeState(status: HomeStatus.initial);
      const state2 = HomeState(status: HomeStatus.initial);
      expect(state1, state2);
    });
  });
}
