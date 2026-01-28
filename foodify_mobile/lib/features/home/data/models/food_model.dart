import '../../domain/entities/food_entity.dart';

class FoodModel extends FoodEntity {
  const FoodModel({
    required super.id,
    required super.restaurantId,
    required super.name,
    required super.image,
    required super.description,
    required super.price,
    required super.category,
    required super.rating,
    required super.isAvailable,
    required super.isPopular,
    super.restaurantName,
    super.restaurantImage,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    // Handle populated restaurantId
    String restaurantId = '';
    String? restaurantName;
    String? restaurantImage;

    if (json['restaurantId'] is String) {
      restaurantId = json['restaurantId'];
    } else if (json['restaurantId'] is Map) {
      restaurantId = json['restaurantId']['_id'] ?? '';
      restaurantName = json['restaurantId']['name'];
      restaurantImage = json['restaurantId']['image'];
    }

    return FoodModel(
      id: json['_id'] ?? '',
      restaurantId: restaurantId,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      isAvailable: json['isAvailable'] ?? true,
      isPopular: json['isPopular'] ?? false,
      restaurantName: restaurantName,
      restaurantImage: restaurantImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'restaurantId': restaurantId,
      'name': name,
      'image': image,
      'description': description,
      'price': price,
      'category': category,
      'rating': rating,
      'isAvailable': isAvailable,
      'isPopular': isPopular,
    };
  }
}
