import 'package:dio/dio.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../../models/order_model.dart';

class OrdersRemoteDataSource {
  final DioClient dioClient;

  OrdersRemoteDataSource({required this.dioClient});

  // Create order
  Future<OrderModel> createOrder({
    required String token,
    required Map<String, dynamic> orderData,
  }) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.createOrder,
        data: orderData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return OrderModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  // Get user orders
  Future<List<OrderModel>> getUserOrders(String token) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.getUserOrders,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> data = response.data['data'];
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get orders: $e');
    }
  }

  // Get current orders
  Future<List<OrderModel>> getCurrentOrders(String token) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.getCurrentOrders,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> data = response.data['data'];
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get current orders: $e');
    }
  }

  // Get order history
  Future<List<OrderModel>> getOrderHistory(String token) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.getOrderHistory,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> data = response.data['data'];
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get order history: $e');
    }
  }

  // Get order by ID
  Future<OrderModel> getOrderById(String token, String orderId) async {
    try {
      final response = await dioClient.dio.get(
        '${ApiEndpoints.getOrderById}/$orderId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return OrderModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }
}
