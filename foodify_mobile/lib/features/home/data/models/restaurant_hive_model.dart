import 'package:hive/hive.dart';
import '../../../../core/constants/hive_table_constants.dart';
import '../../domain/entities/restaurant_entity.dart';

part 'restaurant_hive_model.g.dart';

@HiveType(typeId: HiveTableConstants.restaurantTypeId)
class RestaurantHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final double rating;

  @HiveField(5)
  final String deliveryTime;

  @HiveField(6)
  final double deliveryFee;

  @HiveField(7)
  final List<String> categories;

  @HiveField(8)
  final bool isOpen;

  @HiveField(9)
  final String address;

  @HiveField(10)
  final String phone;

  RestaurantHiveModel({
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

  factory RestaurantHiveModel.fromEntity(RestaurantEntity entity) {
    return RestaurantHiveModel(
      id: entity.id,
      name: entity.name,
      image: entity.image,
      description: entity.description,
      rating: entity.rating,
      deliveryTime: entity.deliveryTime,
      deliveryFee: entity.deliveryFee,
      categories: entity.categories,
      isOpen: entity.isOpen,
      address: entity.address,
      phone: entity.phone,
    );
  }

  RestaurantEntity toEntity() {
    return RestaurantEntity(
      id: id,
      name: name,
      image: image,
      description: description,
      rating: rating,
      deliveryTime: deliveryTime,
      deliveryFee: deliveryFee,
      categories: categories,
      isOpen: isOpen,
      address: address,
      phone: phone,
    );
  }

  static List<RestaurantEntity> toEntityList(List<RestaurantHiveModel> models) {
    return models.map((m) => m.toEntity()).toList();
  }
}
