import 'package:hive/hive.dart';
import '../../../../core/constants/hive_table_constants.dart';
import '../../domain/entities/cart_item_entity.dart';

part 'cart_item_hive_model.g.dart';

@HiveType(typeId: HiveTableConstants.cartTypeId)
class CartItemHiveModel extends HiveObject {
  @HiveField(0)
  final String foodId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final int quantity;

  @HiveField(5)
  final String restaurantId;

  @HiveField(6)
  final String restaurantName;

  CartItemHiveModel({
    required this.foodId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.restaurantId,
    required this.restaurantName,
  });

  factory CartItemHiveModel.fromEntity(CartItemEntity entity) {
    return CartItemHiveModel(
      foodId: entity.foodId,
      name: entity.name,
      image: entity.image,
      price: entity.price,
      quantity: entity.quantity,
      restaurantId: entity.restaurantId,
      restaurantName: entity.restaurantName,
    );
  }

  CartItemEntity toEntity() {
    return CartItemEntity(
      foodId: foodId,
      name: name,
      image: image,
      price: price,
      quantity: quantity,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
    );
  }

  static List<CartItemEntity> toEntityList(List<CartItemHiveModel> models) {
    return models.map((m) => m.toEntity()).toList();
  }
}
