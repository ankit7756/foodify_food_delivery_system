import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import '../../data/datasources/remote/orders_remote_datasource.dart';
import '../../data/datasources/local/orders_local_datasource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;
  final OrdersLocalDataSource localDataSource;

  OrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder({
    required String token,
    required Map<String, dynamic> orderData,
  }) async {
    try {
      if (!await _isOnline()) {
        return Left(
          ServerFailure('No internet connection. Cannot place order offline.'),
        );
      }
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
    if (await _isOnline()) {
      try {
        final orders = await remoteDataSource.getUserOrders(token);
        await localDataSource.cacheOrders(orders);
        return Right(orders);
      } catch (e) {
        final cached = await localDataSource.getCachedOrders();
        if (cached.isNotEmpty) return Right(cached);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      final cached = await localDataSource.getCachedOrders();
      if (cached.isNotEmpty) return Right(cached);
      return Left(ServerFailure('No internet connection.'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getCurrentOrders(
    String token,
  ) async {
    if (await _isOnline()) {
      try {
        final orders = await remoteDataSource.getCurrentOrders(token);
        // ✅ Merge with cached history and save
        final allCached = await localDataSource.getCachedOrders();
        final history = allCached.where((o) => !o.isActive).toList();
        await localDataSource.cacheOrders([...orders, ...history]);
        return Right(orders);
      } catch (e) {
        final cached = await localDataSource.getCachedOrders();
        final current = cached.where((o) => o.isActive).toList();
        if (current.isNotEmpty) return Right(current);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      final cached = await localDataSource.getCachedOrders();
      final current = cached.where((o) => o.isActive).toList();
      return Right(current);
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrderHistory(
    String token,
  ) async {
    if (await _isOnline()) {
      try {
        final orders = await remoteDataSource.getOrderHistory(token);
        // ✅ Merge with cached current orders and save
        final allCached = await localDataSource.getCachedOrders();
        final current = allCached.where((o) => o.isActive).toList();
        await localDataSource.cacheOrders([...current, ...orders]);
        return Right(orders);
      } catch (e) {
        final cached = await localDataSource.getCachedOrders();
        final history = cached.where((o) => !o.isActive).toList();
        if (history.isNotEmpty) return Right(history);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      final cached = await localDataSource.getCachedOrders();
      final history = cached.where((o) => !o.isActive).toList();
      return Right(history);
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(
    String token,
    String orderId,
  ) async {
    try {
      if (await _isOnline()) {
        final order = await remoteDataSource.getOrderById(token, orderId);
        return Right(order);
      } else {
        final cached = await localDataSource.getCachedOrders();
        final found = cached.where((o) => o.id == orderId).toList();
        if (found.isNotEmpty) return Right(found.first);
        return Left(ServerFailure('No internet connection.'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> updateOrderStatus(
    String token,
    String orderId,
    String status,
  ) async {
    try {
      if (!await _isOnline()) {
        return Left(ServerFailure('No internet connection.'));
      }
      final order = await remoteDataSource.updateOrderStatus(
        token,
        orderId,
        status,
      );
      return Right(order);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
