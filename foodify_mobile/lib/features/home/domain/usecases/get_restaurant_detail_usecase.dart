import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../entities/restaurant_entity.dart';
import '../repositories/home_repository.dart';

class GetRestaurantDetailUseCase {
  final HomeRepository repository;

  GetRestaurantDetailUseCase(this.repository);

  Future<Either<Failure, RestaurantEntity>> call(String id) async {
    return await repository.getRestaurantById(id);
  }
}
