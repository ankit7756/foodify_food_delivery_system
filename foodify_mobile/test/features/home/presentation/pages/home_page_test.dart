import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodify_food_delivery_system/features/home/domain/entities/food_entity.dart';
import 'package:foodify_food_delivery_system/features/home/domain/entities/restaurant_entity.dart';
import 'package:foodify_food_delivery_system/features/home/domain/repositories/home_repository.dart';
import 'package:foodify_food_delivery_system/features/home/domain/usecases/get_popular_foods_usecase.dart';
import 'package:foodify_food_delivery_system/features/home/domain/usecases/get_restaurants_usecase.dart';
import 'package:foodify_food_delivery_system/features/home/presentation/pages/home_page.dart';
import 'package:foodify_food_delivery_system/features/home/presentation/providers/home_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodify_food_delivery_system/core/error/faliures.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockRepository;

  final tRestaurants = [
    const RestaurantEntity(
      id: '1',
      name: 'Burger Palace',
      image: 'http://image.com/1.jpg',
      description: 'Best burgers',
      rating: 4.5,
      deliveryTime: '30 min',
      deliveryFee: 50,
      categories: ['Burger'],
      isOpen: true,
      address: 'Kathmandu',
      phone: '9800000000',
    ),
  ];

  final tFoods = [
    const FoodEntity(
      id: '1',
      restaurantId: 'r1',
      name: 'Cheese Burger',
      image: 'http://image.com/b.jpg',
      description: 'Juicy burger',
      price: 350,
      category: 'Burger',
      rating: 4.7,
      isAvailable: true,
      isPopular: true,
    ),
  ];

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepository = MockHomeRepository();
  });

  Widget createTestWidget({bool loadSuccess = true}) {
    if (loadSuccess) {
      when(
        () => mockRepository.getAllRestaurants(),
      ).thenAnswer((_) async => Right(tRestaurants));
      when(
        () => mockRepository.getPopularFoods(),
      ).thenAnswer((_) async => Right(tFoods));
    } else {
      when(
        () => mockRepository.getAllRestaurants(),
      ).thenAnswer((_) async => Left(ServerFailure('Network error')));
      when(
        () => mockRepository.getPopularFoods(),
      ).thenAnswer((_) async => Left(ServerFailure('Network error')));
    }

    return ProviderScope(
      overrides: [
        getRestaurantsUseCaseProvider.overrideWithValue(
          GetRestaurantsUseCase(mockRepository),
        ),
        getPopularFoodsUseCaseProvider.overrideWithValue(
          GetPopularFoodsUseCase(mockRepository),
        ),
      ],
      child: const MaterialApp(home: HomePage()),
    );
  }

  group('HomePage UI Elements', () {
    testWidgets('should display welcome text in header', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text('Hi, Welcome! 👋'), findsOneWidget);
    });

    testWidgets('should display location text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text('Kathmandu, Nepal'), findsOneWidget);
    });

    testWidgets('should display search bar with hint text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text('Search food, restaurants...'), findsOneWidget);
    });

    testWidgets('should show error state when data fails to load', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(loadSuccess: false));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should display search icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should display notification icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });
  });
}
