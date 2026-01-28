import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../entities/food_entity.dart';
import '../repositories/home_repository.dart';

class GetPopularFoodsUseCase {
  final HomeRepository repository;

  GetPopularFoodsUseCase(this.repository);

  Future<Either<Failure, List<FoodEntity>>> call() async {
    return await repository.getPopularFoods();
  }
}
