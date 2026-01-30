import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartState extends Equatable {
  final List<CartItemEntity> items;
  final double deliveryFee;

  const CartState({this.items = const [], this.deliveryFee = 50.0});

  // Calculate subtotal (items only)
  double get subtotal {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  // Calculate grand total (subtotal + delivery fee)
  double get grandTotal {
    return subtotal + deliveryFee;
  }

  // Check if cart has items
  bool get isNotEmpty {
    return items.isNotEmpty;
  }

  // Get total number of items
  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Check if cart is empty
  bool get isEmpty {
    return items.isEmpty;
  }

  // Get restaurant ID (all items should be from same restaurant)
  String? get restaurantId {
    return items.isNotEmpty ? items.first.restaurantId : null;
  }

  // Get restaurant name
  String? get restaurantName {
    return items.isNotEmpty ? items.first.restaurantName : null;
  }

  CartState copyWith({List<CartItemEntity>? items, double? deliveryFee}) {
    return CartState(
      items: items ?? this.items,
      deliveryFee: deliveryFee ?? this.deliveryFee,
    );
  }

  @override
  List<Object?> get props => [items, deliveryFee];
}
