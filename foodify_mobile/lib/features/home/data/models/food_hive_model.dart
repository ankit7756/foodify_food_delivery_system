import 'package:hive/hive.dart';
import '../../../../core/constants/hive_table_constants.dart';
import '../../domain/entities/food_entity.dart';

part 'food_hive_model.g.dart';

@HiveType(typeId: HiveTableConstants.foodTypeId)
class FoodHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String restaurantId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String image;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final double price;

  @HiveField(6)
  final String category;

  @HiveField(7)
  final double rating;

  @HiveField(8)
  final bool isAvailable;

  @HiveField(9)
  final bool isPopular;

  @HiveField(10)
  final String? restaurantName;

  @HiveField(11)
  final String? restaurantImage;

  FoodHiveModel({
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

  factory FoodHiveModel.fromEntity(FoodEntity entity) {
    return FoodHiveModel(
      id: entity.id,
      restaurantId: entity.restaurantId,
      name: entity.name,
      image: entity.image,
      description: entity.description,
      price: entity.price,
      category: entity.category,
      rating: entity.rating,
      isAvailable: entity.isAvailable,
      isPopular: entity.isPopular,
      restaurantName: entity.restaurantName,
      restaurantImage: entity.restaurantImage,
    );
  }

  FoodEntity toEntity() {
    return FoodEntity(
      id: id,
      restaurantId: restaurantId,
      name: name,
      image: image,
      description: description,
      price: price,
      category: category,
      rating: rating,
      isAvailable: isAvailable,
      isPopular: isPopular,
      restaurantName: restaurantName,
      restaurantImage: restaurantImage,
    );
  }

  static List<FoodEntity> toEntityList(List<FoodHiveModel> models) {
    return models.map((m) => m.toEntity()).toList();
  }
}
