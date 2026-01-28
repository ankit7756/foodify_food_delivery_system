import 'package:equatable/equatable.dart';

class RestaurantEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final String description;
  final double rating;
  final String deliveryTime;
  final double deliveryFee;
  final List<String> categories;
  final bool isOpen;
  final String address;
  final String phone;

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.categories,
    required this.isOpen,
    required this.address,
    required this.phone,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    image,
    description,
    rating,
    deliveryTime,
    deliveryFee,
    categories,
    isOpen,
    address,
    phone,
  ];
}
