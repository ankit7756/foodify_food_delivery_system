import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/entities/food_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../../data/datasources/remote/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getAllRestaurants() async {
    try {
      final restaurants = await remoteDataSource.getAllRestaurants();
      return Right(restaurants);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RestaurantEntity>> getRestaurantById(String id) async {
    try {
      final restaurant = await remoteDataSource.getRestaurantById(id);
      return Right(restaurant);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RestaurantEntity>>> searchRestaurants(
    String query,
  ) async {
    try {
      final restaurants = await remoteDataSource.searchRestaurants(query);
      return Right(restaurants);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FoodEntity>>> getPopularFoods() async {
    try {
      final foods = await remoteDataSource.getPopularFoods();
      return Right(foods);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FoodEntity>>> getFoodsByRestaurant(
    String restaurantId,
  ) async {
    try {
      final foods = await remoteDataSource.getFoodsByRestaurant(restaurantId);
      return Right(foods);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FoodEntity>> getFoodById(String id) async {
    try {
      final food = await remoteDataSource.getFoodById(id);
      return Right(food);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
