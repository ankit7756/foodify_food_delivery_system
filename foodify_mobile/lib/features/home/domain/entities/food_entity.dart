import 'package:equatable/equatable.dart';

class FoodEntity extends Equatable {
  final String id;
  final String restaurantId;
  final String name;
  final String image;
  final String description;
  final double price;
  final String category;
  final double rating;
  final bool isAvailable;
  final bool isPopular;
  final String? restaurantName;
  final String? restaurantImage;

  const FoodEntity({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.category,
    required this.rating,
    required this.isAvailable,
    required this.isPopular,
    this.restaurantName,
    this.restaurantImage,
  });

  @override
  List<Object?> get props => [
    id,
    restaurantId,
    name,
    image,
    description,
    price,
    category,
    rating,
    isAvailable,
    isPopular,
    restaurantName,
    restaurantImage,
  ];
}
