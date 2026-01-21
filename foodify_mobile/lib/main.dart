// // import 'package:flutter/material.dart';
// // import 'app.dart';

// // void main() {
// //   runApp(const FoodifyApp());
// // }

// import 'package:flutter/material.dart';
// import 'app/app.dart';

// void main() {
//   runApp(const App());
// }

// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'core/services/hive/hive_service.dart';
// import 'features/auth/data/models/auth_hive_model.dart';
// import 'app/app.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // THIS IS THE FIX
//   await HiveService.initHive(); // Opens box + registers adapter

//   runApp(const App());
// }

import 'package:flutter/material.dart';
import 'package:foodify_food_delivery_system/app/app.dart';
import 'package:foodify_food_delivery_system/core/storage/storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/auth/data/models/auth_hive_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive init
  await Hive.initFlutter();
  Hive.registerAdapter(AuthHiveModelAdapter());

  // SharedPreferences init
  await StorageService.init();

  runApp(const App());
}
