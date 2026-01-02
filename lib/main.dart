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

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/services/hive/hive_service.dart';
import 'features/auth/data/models/auth_hive_model.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // THIS IS THE FIX
  await HiveService.initHive(); // Opens box + registers adapter

  runApp(const App());
}
