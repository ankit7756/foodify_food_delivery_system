import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String foodId;
  final String name;
  final double price;
  final int quantity;
  final String image;

  const OrderItemEntity({
    required this.foodId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });

  double get totalPrice => price * quantity;

  @override
  List<Object?> get props => [foodId, name, price, quantity, image];
}

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final List<OrderItemEntity> items;
  final double subtotal;
  final double deliveryFee;
  final double totalAmount;
  final String deliveryAddress;
  final String phone;
  final String paymentMethod;
  final String status;
  final DateTime orderDate;
  final DateTime? deliveryDate;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.phone,
    required this.paymentMethod,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
  });

  // Get status display text
  String get statusText {
    switch (status) {
      case 'pending':
        return 'Order Placed';
      case 'preparing':
        return 'Preparing';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  // Get status icon
  String get statusIcon {
    switch (status) {
      case 'pending':
        return '📋';
      case 'preparing':
        return '👨‍🍳';
      case 'out_for_delivery':
        return '🚚';
      case 'delivered':
        return '✅';
      case 'cancelled':
        return '❌';
      default:
        return '❓';
    }
  }

  // Check if order is active
  bool get isActive {
    return status == 'pending' ||
        status == 'preparing' ||
        status == 'out_for_delivery';
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    restaurantId,
    restaurantName,
    items,
    subtotal,
    deliveryFee,
    totalAmount,
    deliveryAddress,
    phone,
    paymentMethod,
    status,
    orderDate,
    deliveryDate,
  ];
}
