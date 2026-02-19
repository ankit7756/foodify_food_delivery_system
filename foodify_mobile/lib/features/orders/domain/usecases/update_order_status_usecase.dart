import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class UpdateOrderStatusUseCase {
  final OrdersRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(
    String token,
    String orderId,
    String status,
  ) async {
    return await repository.updateOrderStatus(token, orderId, status);
  }
}
