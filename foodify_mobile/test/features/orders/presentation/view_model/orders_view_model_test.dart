import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodify_food_delivery_system/core/error/faliures.dart';
import 'package:foodify_food_delivery_system/features/orders/domain/entities/order_entity.dart';
import 'package:foodify_food_delivery_system/features/orders/domain/repositories/orders_repository.dart';
import 'package:foodify_food_delivery_system/features/orders/domain/usecases/get_current_order_usecase.dart';
import 'package:foodify_food_delivery_system/features/orders/domain/usecases/get_order_history_usecase.dart';
import 'package:foodify_food_delivery_system/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:foodify_food_delivery_system/features/orders/presentation/providers/orders_providers.dart';
import 'package:foodify_food_delivery_system/features/orders/presentation/state/orders_state.dart';
import 'package:foodify_food_delivery_system/features/orders/presentation/view_model/orders_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockOrdersRepository extends Mock implements OrdersRepository {}

void main() {
  late MockOrdersRepository mockRepository;
  late ProviderContainer container;

  final tOrders = [
    OrderEntity(
      id: 'o1',
      userId: 'u1',
      restaurantId: 'r1',
      restaurantName: 'Test Restaurant',
      items: const [],
      subtotal: 500,
      deliveryFee: 50,
      totalAmount: 550,
      deliveryAddress: 'Kathmandu',
      phone: '9800000000',
      paymentMethod: 'cash',
      status: 'pending',
      orderDate: DateTime(2025, 1, 1),
    ),
  ];

  setUp(() {
    SharedPreferences.setMockInitialValues({'token': 'test_token'});
    mockRepository = MockOrdersRepository();
    container = ProviderContainer(
      overrides: [
        getCurrentOrdersUseCaseProvider.overrideWithValue(
          GetCurrentOrdersUseCase(mockRepository),
        ),
        getOrderHistoryUseCaseProvider.overrideWithValue(
          GetOrderHistoryUseCase(mockRepository),
        ),
        createOrderUseCaseProvider.overrideWithValue(
          CreateOrderUseCase(mockRepository),
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('OrdersViewModel - initial state', () {
    test('should have initial status on creation', () {
      final state = container.read(ordersViewModelProvider);
      expect(state.status, OrdersStatus.initial);
      expect(state.currentOrders, isEmpty);
      expect(state.orderHistory, isEmpty);
      expect(state.errorMessage, isNull);
    });
  });

  group('OrdersState', () {
    test('should have correct initial values', () {
      const state = OrdersState();
      expect(state.status, OrdersStatus.initial);
      expect(state.currentOrders, isEmpty);
      expect(state.orderHistory, isEmpty);
      expect(state.errorMessage, isNull);
    });

    test('copyWith should update status correctly', () {
      const state = OrdersState();
      final newState = state.copyWith(status: OrdersStatus.loading);
      expect(newState.status, OrdersStatus.loading);
      expect(newState.currentOrders, isEmpty);
    });
  });
}
