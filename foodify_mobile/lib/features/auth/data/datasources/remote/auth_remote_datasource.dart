import 'package:foodify_food_delivery_system/core/api/api_client.dart';
import 'package:foodify_food_delivery_system/core/api/api_endpoints.dart';
import 'package:foodify_food_delivery_system/features/auth/data/models/auth_api_model.dart'; // ← CHANGE THIS

class AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSource({required this.client});

  Future<AuthApiModel> register(Map<String, dynamic> body) async {
    final response = await client.post(ApiEndpoints.register, body);
    return AuthApiModel.fromJson(response);
  }

  Future<AuthApiModel> login(Map<String, dynamic> body) async {
    final response = await client.post(ApiEndpoints.login, body);
    return AuthApiModel.fromJson(response);
  }

  Future<Map<String, dynamic>> resetPasswordDirect(
    String email,
    String newPassword,
  ) async {
    final response = await client.post(ApiEndpoints.resetPasswordDirect, {
      'email': email,
      'newPassword': newPassword,
    });
    return response;
  }
}
