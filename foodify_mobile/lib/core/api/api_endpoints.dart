class ApiEndpoints {
  ApiEndpoints._();

  // Auth endpoints
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String getProfile = '/api/auth/profile';
  static const String updateProfile = '/api/auth/profile';

  // Restaurant endpoints
  static const String getAllRestaurants = '/api/restaurants';
  static const String getRestaurantById = '/api/restaurants';
  static const String searchRestaurants = '/api/restaurants/search';

  // Food endpoints
  static const String getAllFoods = '/api/foods';
  static const String getPopularFoods = '/api/foods/popular';
  static const String getFoodsByRestaurant = '/api/foods/restaurant';
  static const String getFoodById = '/api/foods';
}
