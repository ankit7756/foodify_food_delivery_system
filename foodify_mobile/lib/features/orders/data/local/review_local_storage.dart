import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewLocalStorage {
  static const String _key = 'foodify_reviews';

  // Save a review
  static Future<void> saveReview({
    required String orderId,
    required int rating,
    required String message,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_key);
    Map<String, dynamic> reviews = {};
    if (existing != null) {
      reviews = jsonDecode(existing);
    }
    reviews[orderId] = {
      'rating': rating,
      'message': message,
      'reviewedAt': DateTime.now().toIso8601String(),
    };
    await prefs.setString(_key, jsonEncode(reviews));
  }

  // Get review for a specific order
  static Future<Map<String, dynamic>?> getReview(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_key);
    if (existing == null) return null;
    final reviews = jsonDecode(existing) as Map<String, dynamic>;
    return reviews[orderId] as Map<String, dynamic>?;
  }

  // Check if order has been reviewed
  static Future<bool> hasReview(String orderId) async {
    final review = await getReview(orderId);
    return review != null;
  }
}
