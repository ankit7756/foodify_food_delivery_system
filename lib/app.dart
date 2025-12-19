// // import 'package:flutter/material.dart';
// // import 'screens/splash_screen.dart';

// // class FoodifyApp extends StatelessWidget {
// //   const FoodifyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Foodify',
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(useMaterial3: true, primarySwatch: Colors.deepOrange),
// //       home: const SplashScreen(),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'theme/app_colors.dart';
// import 'screens/splash_screen.dart';

// class FoodifyApp extends StatelessWidget {
//   const FoodifyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Foodify',
//       theme: ThemeData(
//         scaffoldBackgroundColor: AppColors.background,
//         fontFamily: 'OpenSans',
//         primaryColor: AppColors.primary,
//         textTheme: const TextTheme(
//           bodyMedium: TextStyle(color: AppColors.textPrimary),
//           bodySmall: TextStyle(color: AppColors.textSecondary),
//         ),
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'theme/theme_data.dart';
import 'screens/splash_screen.dart';

class FoodifyApp extends StatelessWidget {
  const FoodifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodify',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: const SplashScreen(),
    );
  }
}
