import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_food_delivery_system/features/auth/presentation/pages/forgot_password_screen.dart';

void main() {
  Widget createTestWidget() {
    return const ProviderScope(
      child: MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(800, 1400)),
          child: ForgotPasswordPage(),
        ),
      ),
    );
  }

  group('ForgotPasswordPage UI Elements', () {
    testWidgets('should display Reset Password title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Reset Password'), findsWidgets);
    });

    testWidgets('should display three text fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(TextField), findsNWidgets(3));
    });

    testWidgets('should display Reset Password button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Reset Password'), findsWidgets);
    });

    testWidgets('should display back to Login link', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should display email icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });
  });

  group('ForgotPasswordPage Form Validation', () {
    testWidgets('should show error when email is empty', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pump();
      await tester.tap(find.text('Reset Password').last);
      await tester.pump();
      expect(find.text('Email cannot be empty'), findsOneWidget);
    });

    testWidgets('should show error when email is invalid', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextField).first, 'bademail');
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pump();
      await tester.tap(find.text('Reset Password').last);
      await tester.pump();
      expect(find.text('Enter a valid email ending with .com'), findsOneWidget);
    });

    testWidgets('should show error when new password is empty', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pump();
      await tester.tap(find.text('Reset Password').last);
      await tester.pump();
      expect(find.text('New password cannot be empty'), findsOneWidget);
    });

    testWidgets('should show error when passwords do not match', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.enterText(find.byType(TextField).at(2), 'differentpass');
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pump();
      await tester.tap(find.text('Reset Password').last);
      await tester.pump();
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should show error when confirm password is empty', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pump();
      await tester.tap(find.text('Reset Password').last);
      await tester.pump();
      expect(find.text('Please confirm your password'), findsOneWidget);
    });
  });
}
