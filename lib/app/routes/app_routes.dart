import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const dashboard = '/dashboard';

  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const Scaffold(body: Center(child: Text('Splash'))),
    login: (_) => const Scaffold(body: Center(child: Text('Login'))),
    dashboard: (_) => const Scaffold(body: Center(child: Text('Dashboard'))),
  };
}
