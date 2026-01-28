import '../../domain/entities/restaurant_entity.dart';

class RestaurantModel extends RestaurantEntity {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.image,
    required super.description,
    required super.rating,
    required super.deliveryTime,
    required super.deliveryFee,
    required super.categories,
    required super.isOpen,
    required super.address,
    required super.phone,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      deliveryTime: json['deliveryTime'] ?? '',
      deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
      categories: List<String>.from(json['categories'] ?? []),
      isOpen: json['isOpen'] ?? true,
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'description': description,
      'rating': rating,
      'deliveryTime': deliveryTime,
      'deliveryFee': deliveryFee,
      'categories': categories,
      'isOpen': isOpen,
      'address': address,
      'phone': phone,
    };
  }
}
