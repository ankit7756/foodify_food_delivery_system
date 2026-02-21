import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodify_food_delivery_system/app/app.dart';
import 'package:foodify_food_delivery_system/core/storage/storage_service.dart';
import 'package:foodify_food_delivery_system/core/services/hive/hive_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/core_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initHive();
  await StorageService.init();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const App(),
    ),
  );
}
