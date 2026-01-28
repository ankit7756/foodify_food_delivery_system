import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../entities/food_entity.dart';
import '../repositories/home_repository.dart';

class GetFoodDetailUseCase {
  final HomeRepository repository;

  GetFoodDetailUseCase(this.repository);

  Future<Either<Failure, FoodEntity>> call(String id) async {
    return await repository.getFoodById(id);
  }
}
