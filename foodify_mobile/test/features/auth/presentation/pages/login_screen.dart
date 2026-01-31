import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodify_food_delivery_system/features/auth/presentation/pages/login_screen.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('should display all login screen widgets', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );

      // Assert
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('should display email and password text fields', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );

      // Assert
      expect(find.byType(TextField), findsNWidgets(2)); // Email and Password
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should display login button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );

      // Assert
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      expect(loginButton, findsOneWidget);
    });

    testWidgets('should allow entering email and password', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );

      // Act
      final emailField = find.widgetWithText(TextField, 'Email');
      final passwordField = find.widgetWithText(TextField, 'Password');

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Assert
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('should display social login buttons', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );

      // Assert
      expect(find.text('or continue with'), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(3)); // Logo + 2 social buttons
    });

    testWidgets('should toggle password visibility', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );

      // Act - Find and tap the visibility toggle button
      final visibilityToggle = find.byIcon(Icons.visibility_off_outlined);
      expect(visibilityToggle, findsOneWidget);

      await tester.tap(visibilityToggle);
      await tester.pump();

      // Assert - Icon should change to visibility icon
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets(
      'should display error when email is empty and login is tapped',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: LoginScreen())),
        );

        // Act
        final loginButton = find.widgetWithText(ElevatedButton, 'Login');
        await tester.tap(loginButton);
        await tester.pump();

        // Assert
        expect(find.text('Email cannot be empty'), findsOneWidget);
      },
    );

    testWidgets('should display Foodify logo', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );

      // Assert
      expect(find.byType(Image), findsWidgets);
    });
  });
}
