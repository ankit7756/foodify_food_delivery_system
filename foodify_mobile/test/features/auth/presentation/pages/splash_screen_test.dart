import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../lib/features/splash/presentation/pages/splash_screen.dart';

void main() {
  group('SplashScreen Widget Tests', () {
    testWidgets('should display Foodify app name', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      // Assert
      expect(find.text('Foodify'), findsOneWidget);
    });

    testWidgets('should display tagline', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      // Assert
      expect(find.text('Delicious food, delivered fast'), findsOneWidget);
    });

    testWidgets('should display loading text', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      // Assert
      expect(find.text('Loading your experience...'), findsOneWidget);
    });

    testWidgets('should display restaurant menu icon', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      // Assert
      expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
    });

    testWidgets('should have gradient background container', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      // Assert
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(Scaffold),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isNotNull);
    });

    testWidgets('should display circular decorative containers', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      // Assert - Should have multiple containers for decoration
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should have proper widget hierarchy', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Stack), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should display logo in circular container', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      // Assert
      expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
    });
  });
}
