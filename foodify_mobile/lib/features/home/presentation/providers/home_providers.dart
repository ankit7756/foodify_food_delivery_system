import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/remote/home_remote_datasource.dart';
import '../../domain/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_restaurants_usecase.dart';
import '../../domain/usecases/get_popular_foods_usecase.dart';
import '../../domain/usecases/get_restaurant_detail_usecase.dart';
import '../../domain/usecases/get_foods_by_resturant_usecase.dart';
import '../../domain/usecases/get_food_detail_usecase.dart';

// Data Source
final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return HomeRemoteDataSource(dioClient: dioClient);
});

// Repository
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final remoteDataSource = ref.read(homeRemoteDataSourceProvider);
  return HomeRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Use Cases
final getRestaurantsUseCaseProvider = Provider<GetRestaurantsUseCase>((ref) {
  final repository = ref.read(homeRepositoryProvider);
  return GetRestaurantsUseCase(repository);
});

final getPopularFoodsUseCaseProvider = Provider<GetPopularFoodsUseCase>((ref) {
  final repository = ref.read(homeRepositoryProvider);
  return GetPopularFoodsUseCase(repository);
});

final getRestaurantDetailUseCaseProvider = Provider<GetRestaurantDetailUseCase>(
  (ref) {
    final repository = ref.read(homeRepositoryProvider);
    return GetRestaurantDetailUseCase(repository);
  },
);

final getFoodsByRestaurantUseCaseProvider =
    Provider<GetFoodsByRestaurantUseCase>((ref) {
      final repository = ref.read(homeRepositoryProvider);
      return GetFoodsByRestaurantUseCase(repository);
    });

final getFoodDetailUseCaseProvider = Provider<GetFoodDetailUseCase>((ref) {
  final repository = ref.read(homeRepositoryProvider);
  return GetFoodDetailUseCase(repository);
});
