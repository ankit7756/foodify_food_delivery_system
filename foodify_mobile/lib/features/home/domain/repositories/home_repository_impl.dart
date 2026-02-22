import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/entities/food_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../../data/datasources/remote/home_remote_datasource.dart';
import '../../data/datasources/local/home_local_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getAllRestaurants() async {
    if (await _isOnline()) {
      try {
        final restaurants = await remoteDataSource.getAllRestaurants();
        // Cache after successful API call
        await localDataSource.cacheRestaurants(restaurants);
        return Right(restaurants);
      } catch (e) {
        // API failed — try cache
        final cached = await localDataSource.getCachedRestaurants();
        if (cached.isNotEmpty) return Right(cached);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Offline — load from cache
      final cached = await localDataSource.getCachedRestaurants();
      if (cached.isNotEmpty) return Right(cached);
      return Left(
        ServerFailure('No internet connection and no cached data available.'),
      );
    }
  }

  @override
  Future<Either<Failure, List<FoodEntity>>> getPopularFoods() async {
    if (await _isOnline()) {
      try {
        final foods = await remoteDataSource.getPopularFoods();
        await localDataSource.cacheFoods(foods);
        return Right(foods);
      } catch (e) {
        final cached = await localDataSource.getCachedFoods();
        if (cached.isNotEmpty) return Right(cached);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      final cached = await localDataSource.getCachedFoods();
      if (cached.isNotEmpty) return Right(cached);
      return Left(
        ServerFailure('No internet connection and no cached data available.'),
      );
    }
  }

  @override
  Future<Either<Failure, RestaurantEntity>> getRestaurantById(String id) async {
    try {
      if (await _isOnline()) {
        final restaurant = await remoteDataSource.getRestaurantById(id);
        return Right(restaurant);
      } else {
        final cached = await localDataSource.getCachedRestaurants();
        final found = cached.where((r) => r.id == id).toList();
        if (found.isNotEmpty) return Right(found.first);
        return Left(ServerFailure('No internet connection.'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RestaurantEntity>>> searchRestaurants(
    String query,
  ) async {
    try {
      if (await _isOnline()) {
        final restaurants = await remoteDataSource.searchRestaurants(query);
        return Right(restaurants);
      } else {
        // Search cached restaurants locally
        final cached = await localDataSource.getCachedRestaurants();
        final filtered = cached
            .where(
              (r) =>
                  r.name.toLowerCase().contains(query.toLowerCase()) ||
                  r.categories.any(
                    (c) => c.toLowerCase().contains(query.toLowerCase()),
                  ),
            )
            .toList();
        return Right(filtered);
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FoodEntity>>> getFoodsByRestaurant(
    String restaurantId,
  ) async {
    try {
      if (await _isOnline()) {
        final foods = await remoteDataSource.getFoodsByRestaurant(restaurantId);
        final existingCached = await localDataSource.getCachedFoods();
        final otherFoods = existingCached
            .where((f) => f.restaurantId != restaurantId)
            .toList();
        await localDataSource.cacheFoods([...otherFoods, ...foods]);
        return Right(foods);
      } else {
        final cached = await localDataSource.getCachedFoods();
        final filtered = cached
            .where((f) => f.restaurantId == restaurantId)
            .toList();
        return Right(filtered);
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FoodEntity>> getFoodById(String id) async {
    try {
      if (await _isOnline()) {
        final food = await remoteDataSource.getFoodById(id);
        return Right(food);
      } else {
        final cached = await localDataSource.getCachedFoods();
        final found = cached.where((f) => f.id == id).toList();
        if (found.isNotEmpty) return Right(found.first);
        return Left(ServerFailure('No internet connection.'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
