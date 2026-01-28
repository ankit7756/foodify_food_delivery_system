import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../entities/restaurant_entity.dart';
import '../repositories/home_repository.dart';

class GetRestaurantsUseCase {
  final HomeRepository repository;

  GetRestaurantsUseCase(this.repository);

  Future<Either<Failure, List<RestaurantEntity>>> call() async {
    return await repository.getAllRestaurants();
  }
}
