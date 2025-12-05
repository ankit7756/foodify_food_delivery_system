import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

class FoodifyApp extends StatelessWidget {
  const FoodifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.deepOrange),
      home: const SplashScreen(),
    );
  }
}
