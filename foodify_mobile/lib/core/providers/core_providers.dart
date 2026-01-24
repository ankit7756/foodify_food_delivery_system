import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';

// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

// Dio Client Provider
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});
