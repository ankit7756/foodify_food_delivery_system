import 'package:dio/dio.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../../models/restaurant_model.dart';
import '../../models/food_model.dart';

class HomeRemoteDataSource {
  final DioClient dioClient;

  HomeRemoteDataSource({required this.dioClient});

  // Get all restaurants
  Future<List<RestaurantModel>> getAllRestaurants() async {
    try {
      final response = await dioClient.get(ApiEndpoints.getAllRestaurants);
      final List<dynamic> data = response.data['data'];
      return data.map((json) => RestaurantModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get restaurants: $e');
    }
  }

  // Get restaurant by ID
  Future<RestaurantModel> getRestaurantById(String id) async {
    try {
      final response = await dioClient.get(
        '${ApiEndpoints.getRestaurantById}/$id',
      );
      return RestaurantModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to get restaurant: $e');
    }
  }

  // Search restaurants
  Future<List<RestaurantModel>> searchRestaurants(String query) async {
    try {
      final response = await dioClient.get(
        '${ApiEndpoints.searchRestaurants}?query=$query',
      );
      final List<dynamic> data = response.data['data'];
      return data.map((json) => RestaurantModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search restaurants: $e');
    }
  }

  // Get popular foods
  Future<List<FoodModel>> getPopularFoods() async {
    try {
      final response = await dioClient.get(ApiEndpoints.getPopularFoods);
      final List<dynamic> data = response.data['data'];
      return data.map((json) => FoodModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get popular foods: $e');
    }
  }

  // Get foods by restaurant
  Future<List<FoodModel>> getFoodsByRestaurant(String restaurantId) async {
    try {
      final response = await dioClient.get(
        '${ApiEndpoints.getFoodsByRestaurant}/$restaurantId',
      );
      final List<dynamic> data = response.data['data'];
      return data.map((json) => FoodModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get foods: $e');
    }
  }

  // Get food by ID
  Future<FoodModel> getFoodById(String id) async {
    try {
      final response = await dioClient.get('${ApiEndpoints.getFoodById}/$id');
      return FoodModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to get food: $e');
    }
  }
}
