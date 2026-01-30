import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class GetOrderDetailUseCase {
  final OrdersRepository repository;

  GetOrderDetailUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(
    String token,
    String orderId,
  ) async {
    return await repository.getOrderById(token, orderId);
  }
}
