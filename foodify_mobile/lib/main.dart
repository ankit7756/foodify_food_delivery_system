import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodify_food_delivery_system/app/app.dart';
import 'package:foodify_food_delivery_system/core/storage/storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/data/models/auth_hive_model.dart';
import 'core/providers/core_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive init
  await Hive.initFlutter();
  Hive.registerAdapter(AuthHiveModelAdapter());

  // SharedPreferences init
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
