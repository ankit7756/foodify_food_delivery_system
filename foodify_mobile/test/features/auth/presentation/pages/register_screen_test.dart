import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodify_food_delivery_system/features/auth/presentation/pages/register_screen.dart';

void main() {
  group('RegisterScreen Widget Tests', () {
    testWidgets('should display all register screen widgets', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: RegisterScreen())),
      );

      // Assert
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Sign up to get started'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should display all 5 input fields', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: RegisterScreen())),
      );

      // Assert
      expect(find.byType(TextField), findsNWidgets(5));
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
    });

    testWidgets('should allow entering all registration fields', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: RegisterScreen())),
      );

      // Act
      await tester.enterText(
        find.widgetWithText(TextField, 'Username'),
        'johndoe',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Email'),
        'ankit@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Full Name'),
        'Ankit',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Phone Number'),
        '9876543210',
      );
      await tester.pump();

      // Assert
      expect(find.text('johndoe'), findsOneWidget);
      expect(find.text('ankit@example.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
      expect(find.text('Ankit'), findsOneWidget);
      expect(find.text('9876543210'), findsOneWidget);
    });

    testWidgets('should display register button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: RegisterScreen())),
      );

      // Assert
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      expect(registerButton, findsOneWidget);
    });

    testWidgets('should toggle password visibility', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: RegisterScreen())),
      );

      // Act
      final visibilityToggle = find.byIcon(Icons.visibility_off_outlined);
      await tester.tap(visibilityToggle);
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('should display error when username is empty', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: RegisterScreen())),
      );

      // Act
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      await tester.ensureVisible(registerButton);
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Username cannot be empty'), findsOneWidget);
    });

    testWidgets('should display Foodify logo', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: RegisterScreen())),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should have proper field icons', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: RegisterScreen())),
      );

      // Assert
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byIcon(Icons.badge_outlined), findsOneWidget);
      expect(find.byIcon(Icons.phone_outlined), findsOneWidget);
    });
  });
}
