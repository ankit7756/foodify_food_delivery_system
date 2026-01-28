import 'package:equatable/equatable.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/entities/food_entity.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<RestaurantEntity> restaurants;
  final List<FoodEntity> popularFoods;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.restaurants = const [],
    this.popularFoods = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<RestaurantEntity>? restaurants,
    List<FoodEntity>? popularFoods,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      restaurants: restaurants ?? this.restaurants,
      popularFoods: popularFoods ?? this.popularFoods,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, restaurants, popularFoods, errorMessage];
}
