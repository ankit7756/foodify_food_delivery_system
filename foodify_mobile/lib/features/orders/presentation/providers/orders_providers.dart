import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/remote/orders_remote_datasource.dart';
import '../../domain/repositories/orders_repository_impl.dart';
import '../../domain/repositories/orders_repository.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/get_current_order_usecase.dart';
import '../../domain/usecases/get_order_history_usecase.dart';
import '../../domain/usecases/get_order_detail_usecase.dart';

// Data Source
final ordersRemoteDataSourceProvider = Provider<OrdersRemoteDataSource>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return OrdersRemoteDataSource(dioClient: dioClient);
});

// Repository
final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  final remoteDataSource = ref.read(ordersRemoteDataSourceProvider);
  return OrdersRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Use Cases
final createOrderUseCaseProvider = Provider<CreateOrderUseCase>((ref) {
  final repository = ref.read(ordersRepositoryProvider);
  return CreateOrderUseCase(repository);
});

final getCurrentOrdersUseCaseProvider = Provider<GetCurrentOrdersUseCase>((
  ref,
) {
  final repository = ref.read(ordersRepositoryProvider);
  return GetCurrentOrdersUseCase(repository);
});

final getOrderHistoryUseCaseProvider = Provider<GetOrderHistoryUseCase>((ref) {
  final repository = ref.read(ordersRepositoryProvider);
  return GetOrderHistoryUseCase(repository);
});

final getOrderDetailUseCaseProvider = Provider<GetOrderDetailUseCase>((ref) {
  final repository = ref.read(ordersRepositoryProvider);
  return GetOrderDetailUseCase(repository);
});
