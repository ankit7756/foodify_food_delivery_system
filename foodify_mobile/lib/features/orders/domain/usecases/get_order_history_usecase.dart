import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class GetOrderHistoryUseCase {
  final OrdersRepository repository;

  GetOrderHistoryUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call(String token) async {
    return await repository.getOrderHistory(token);
  }
}
