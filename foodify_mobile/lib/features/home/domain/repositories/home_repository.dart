import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../entities/restaurant_entity.dart';
import '../entities/food_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<RestaurantEntity>>> getAllRestaurants();
  Future<Either<Failure, RestaurantEntity>> getRestaurantById(String id);
  Future<Either<Failure, List<RestaurantEntity>>> searchRestaurants(
    String query,
  );
  Future<Either<Failure, List<FoodEntity>>> getPopularFoods();
  Future<Either<Failure, List<FoodEntity>>> getFoodsByRestaurant(
    String restaurantId,
  );
  Future<Either<Failure, FoodEntity>> getFoodById(String id);
}
