import '../../../../../core/services/hive/hive_service.dart';
import '../../models/restaurant_hive_model.dart';
import '../../models/food_hive_model.dart';
import '../../../domain/entities/restaurant_entity.dart';
import '../../../domain/entities/food_entity.dart';

class HomeLocalDataSource {
  Future<void> cacheRestaurants(List<RestaurantEntity> restaurants) async {
    final models = restaurants
        .map((r) => RestaurantHiveModel.fromEntity(r))
        .toList();
    await HiveService.saveRestaurants(models);
  }

  Future<List<RestaurantEntity>> getCachedRestaurants() async {
    final models = HiveService.getCachedRestaurants();
    return RestaurantHiveModel.toEntityList(models);
  }

  Future<void> cacheFoods(List<FoodEntity> foods) async {
    final models = foods.map((f) => FoodHiveModel.fromEntity(f)).toList();
    await HiveService.saveFoods(models);
  }

  Future<List<FoodEntity>> getCachedFoods() async {
    final models = HiveService.getCachedFoods();
    return FoodHiveModel.toEntityList(models);
  }

  bool hasCachedData() {
    return HiveService.getCachedRestaurants().isNotEmpty;
  }
}
