import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import '../../data/datasources/remote/orders_remote_datasource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OrderEntity>> createOrder({
    required String token,
    required Map<String, dynamic> orderData,
  }) async {
    try {
      final order = await remoteDataSource.createOrder(
        token: token,
        orderData: orderData,
      );
      return Right(order);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getUserOrders(String token) async {
    try {
      final orders = await remoteDataSource.getUserOrders(token);
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getCurrentOrders(
    String token,
  ) async {
    try {
      final orders = await remoteDataSource.getCurrentOrders(token);
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrderHistory(
    String token,
  ) async {
    try {
      final orders = await remoteDataSource.getOrderHistory(token);
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(
    String token,
    String orderId,
  ) async {
    try {
      final order = await remoteDataSource.getOrderById(token, orderId);
      return Right(order);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
