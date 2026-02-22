import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodify_food_delivery_system/core/error/faliures.dart';
import 'package:foodify_food_delivery_system/features/orders/domain/entities/order_entity.dart';
import 'package:foodify_food_delivery_system/features/orders/domain/repositories/orders_repository.dart';
import 'package:foodify_food_delivery_system/features/orders/domain/usecases/get_current_order_usecase.dart';

class MockOrdersRepository extends Mock implements OrdersRepository {}

void main() {
  late MockOrdersRepository mockRepository;
  late GetCurrentOrdersUseCase useCase;

  setUp(() {
    mockRepository = MockOrdersRepository();
    useCase = GetCurrentOrdersUseCase(mockRepository);
  });

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

  group('GetCurrentOrdersUseCase', () {
    test('should return list of current orders on success', () async {
      when(
        () => mockRepository.getCurrentOrders(any()),
      ).thenAnswer((_) async => Right(tOrders));

      final result = await useCase('test_token');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected success'),
        (orders) => expect(orders, tOrders),
      );
      verify(() => mockRepository.getCurrentOrders('test_token')).called(1);
    });

    test('should return ServerFailure when repository fails', () async {
      when(
        () => mockRepository.getCurrentOrders(any()),
      ).thenAnswer((_) async => Left(ServerFailure('Network error')));

      final result = await useCase('test_token');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('should pass correct token to repository', () async {
      when(
        () => mockRepository.getCurrentOrders(any()),
      ).thenAnswer((_) async => Right(tOrders));

      await useCase('my_token');

      verify(() => mockRepository.getCurrentOrders('my_token')).called(1);
    });
  });
}
