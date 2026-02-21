import 'package:hive/hive.dart';
import '../../../../core/constants/hive_table_constants.dart';
import '../../domain/entities/order_entity.dart';

part 'order_hive_model.g.dart';

@HiveType(typeId: HiveTableConstants.orderTypeId)
class OrderHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String restaurantId;

  @HiveField(3)
  final String restaurantName;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final double totalAmount;

  @HiveField(6)
  final double subtotal;

  @HiveField(7)
  final double deliveryFee;

  @HiveField(8)
  final String deliveryAddress;

  @HiveField(9)
  final String phone;

  @HiveField(10)
  final String paymentMethod;

  @HiveField(11)
  final DateTime orderDate;

  @HiveField(12)
  final DateTime? deliveryDate;

  @HiveField(13)
  final List<String> itemsJson;

  OrderHiveModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.status,
    required this.totalAmount,
    required this.subtotal,
    required this.deliveryFee,
    required this.deliveryAddress,
    required this.phone,
    required this.paymentMethod,
    required this.orderDate,
    this.deliveryDate,
    required this.itemsJson,
  });

  factory OrderHiveModel.fromEntity(OrderEntity entity) {
    return OrderHiveModel(
      id: entity.id,
      userId: entity.userId,
      restaurantId: entity.restaurantId,
      restaurantName: entity.restaurantName,
      status: entity.status,
      totalAmount: entity.totalAmount,
      subtotal: entity.subtotal,
      deliveryFee: entity.deliveryFee,
      deliveryAddress: entity.deliveryAddress,
      phone: entity.phone,
      paymentMethod: entity.paymentMethod,
      orderDate: entity.orderDate,
      deliveryDate: entity.deliveryDate,
      // Store each item as pipe-separated string
      itemsJson: entity.items
          .map(
            (item) =>
                '${item.foodId}|${item.name}|${item.image}|${item.price}|${item.quantity}',
          )
          .toList(),
    );
  }

  OrderEntity toEntity() {
    final items = itemsJson.map((itemStr) {
      final parts = itemStr.split('|');
      return OrderItemEntity(
        foodId: parts[0],
        name: parts[1],
        image: parts[2],
        price: double.parse(parts[3]),
        quantity: int.parse(parts[4]),
      );
    }).toList();

    return OrderEntity(
      id: id,
      userId: userId,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      status: status,
      totalAmount: totalAmount,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      deliveryAddress: deliveryAddress,
      phone: phone,
      paymentMethod: paymentMethod,
      orderDate: orderDate,
      deliveryDate: deliveryDate,
      items: items,
    );
  }

  static List<OrderEntity> toEntityList(List<OrderHiveModel> models) {
    return models.map((m) => m.toEntity()).toList();
  }
}
