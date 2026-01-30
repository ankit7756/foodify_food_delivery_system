import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

enum OrdersStatus { initial, loading, loaded, creating, created, error }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<OrderEntity> currentOrders;
  final List<OrderEntity> orderHistory;
  final String? errorMessage;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.currentOrders = const [],
    this.orderHistory = const [],
    this.errorMessage,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    List<OrderEntity>? currentOrders,
    List<OrderEntity>? orderHistory,
    String? errorMessage,
  }) {
    return OrdersState(
      status: status ?? this.status,
      currentOrders: currentOrders ?? this.currentOrders,
      orderHistory: orderHistory ?? this.orderHistory,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentOrders,
    orderHistory,
    errorMessage,
  ];
}
