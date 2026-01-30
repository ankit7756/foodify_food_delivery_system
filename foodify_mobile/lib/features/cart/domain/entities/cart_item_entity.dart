import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String foodId;
  final String name;
  final String image;
  final double price;
  final int quantity;
  final String restaurantId;
  final String restaurantName;

  const CartItemEntity({
    required this.foodId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.restaurantId,
    required this.restaurantName,
  });

  // Calculate total price for this item
  double get totalPrice => price * quantity;

  // Create a copy with updated quantity
  CartItemEntity copyWith({
    String? foodId,
    String? name,
    String? image,
    double? price,
    int? quantity,
    String? restaurantId,
    String? restaurantName,
  }) {
    return CartItemEntity(
      foodId: foodId ?? this.foodId,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
    );
  }

  @override
  List<Object?> get props => [
    foodId,
    name,
    image,
    price,
    quantity,
    restaurantId,
    restaurantName,
  ];
}
