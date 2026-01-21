import 'package:flutter/material.dart';
import '../features/auth/presentation/pages/splash_screen.dart';
import 'theme/theme_data.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foodify',
      theme: getApplicationTheme(), // your theme from theme_data.dart
      home: const SplashScreen(), // start with splash screen
    );
  }
}
