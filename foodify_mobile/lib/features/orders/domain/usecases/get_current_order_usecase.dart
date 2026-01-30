import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class GetCurrentOrdersUseCase {
  final OrdersRepository repository;

  GetCurrentOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call(String token) async {
    return await repository.getCurrentOrders(token);
  }
}
