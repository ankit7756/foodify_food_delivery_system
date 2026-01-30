import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../entities/order_entity.dart';

abstract class OrdersRepository {
  Future<Either<Failure, OrderEntity>> createOrder({
    required String token,
    required Map<String, dynamic> orderData,
  });

  Future<Either<Failure, List<OrderEntity>>> getUserOrders(String token);
  Future<Either<Failure, List<OrderEntity>>> getCurrentOrders(String token);
  Future<Either<Failure, List<OrderEntity>>> getOrderHistory(String token);
  Future<Either<Failure, OrderEntity>> getOrderById(
    String token,
    String orderId,
  );
}
