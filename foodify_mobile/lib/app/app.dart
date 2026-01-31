import 'package:flutter/material.dart';
import '../features/splash/presentation/pages/splash_screen.dart';
import 'theme/theme_data.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foodify',
      theme: getApplicationTheme(),
      home: const SplashScreen(),
    );
  }
}
