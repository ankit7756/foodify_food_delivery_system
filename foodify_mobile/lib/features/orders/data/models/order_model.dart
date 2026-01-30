import '../../domain/entities/order_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.foodId,
    required super.name,
    required super.price,
    required super.quantity,
    required super.image,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      foodId: json['foodId'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }
}

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.restaurantId,
    required super.restaurantName,
    required super.items,
    required super.subtotal,
    required super.deliveryFee,
    required super.totalAmount,
    required super.deliveryAddress,
    required super.phone,
    required super.paymentMethod,
    required super.status,
    required super.orderDate,
    super.deliveryDate,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Handle restaurantId - can be String or Object
    String restaurantId = '';
    if (json['restaurantId'] is String) {
      restaurantId = json['restaurantId'];
    } else if (json['restaurantId'] is Map) {
      restaurantId = json['restaurantId']['_id'] ?? '';
    }

    return OrderModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      restaurantId: restaurantId, // ✅ FIXED
      restaurantName: json['restaurantName'] ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItemModel.fromJson(item))
              .toList() ??
          [],
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      deliveryAddress: json['deliveryAddress'] ?? '',
      phone: json['phone'] ?? '',
      paymentMethod: json['paymentMethod'] ?? 'Cash on Delivery',
      status: json['status'] ?? 'pending',
      orderDate: json['orderDate'] != null
          ? DateTime.parse(json['orderDate'])
          : DateTime.now(),
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'items': items.map((item) => (item as OrderItemModel).toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'totalAmount': totalAmount,
      'deliveryAddress': deliveryAddress,
      'phone': phone,
      'paymentMethod': paymentMethod,
      'status': status,
      'orderDate': orderDate.toIso8601String(),
      if (deliveryDate != null) 'deliveryDate': deliveryDate!.toIso8601String(),
    };
  }
}
