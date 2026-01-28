import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../entities/food_entity.dart';
import '../repositories/home_repository.dart';

class GetFoodsByRestaurantUseCase {
  final HomeRepository repository;

  GetFoodsByRestaurantUseCase(this.repository);

  Future<Either<Failure, List<FoodEntity>>> call(String restaurantId) async {
    return await repository.getFoodsByRestaurant(restaurantId);
  }
}
