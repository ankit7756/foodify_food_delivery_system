import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class CreateOrderUseCase {
  final OrdersRepository repository;

  CreateOrderUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call({
    required String token,
    required Map<String, dynamic> orderData,
  }) async {
    return await repository.createOrder(token: token, orderData: orderData);
  }
}
