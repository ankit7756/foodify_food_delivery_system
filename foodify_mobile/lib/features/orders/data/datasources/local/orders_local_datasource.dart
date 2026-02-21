import '../../../../../core/services/hive/hive_service.dart';
import '../../models/order_hive_model.dart';
import '../../../domain/entities/order_entity.dart';

class OrdersLocalDataSource {
  Future<void> cacheOrders(List<OrderEntity> orders) async {
    final models = orders.map((o) => OrderHiveModel.fromEntity(o)).toList();
    await HiveService.saveOrders(models);
  }

  Future<List<OrderEntity>> getCachedOrders() async {
    final models = HiveService.getCachedOrders();
    return OrderHiveModel.toEntityList(models);
  }

  bool hasCachedOrders() {
    return HiveService.getCachedOrders().isNotEmpty;
  }
}
