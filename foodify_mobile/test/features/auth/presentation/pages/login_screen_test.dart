import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodify_food_delivery_system/features/auth/data/models/auth_api_model.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/usecases/logout_usecase.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/usecases/register_usecase.dart';
import 'package:foodify_food_delivery_system/features/auth/presentation/pages/login_screen.dart';
import 'package:foodify_food_delivery_system/features/auth/presentation/providers/auth_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepository = MockAuthRepository();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        loginUseCaseProvider.overrideWithValue(LoginUseCase(mockRepository)),
        registerUseCaseProvider.overrideWithValue(
          RegisterUseCase(mockRepository),
        ),
        logoutUseCaseProvider.overrideWithValue(LogoutUseCase()),
      ],
      child: const MaterialApp(home: LoginScreen()),
    );
  }

  group('LoginScreen UI Elements', () {
    testWidgets('should display Welcome Back text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Welcome Back!'), findsOneWidget);
    });

    testWidgets('should display Sign in to continue text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Sign in to continue'), findsOneWidget);
    });

    testWidgets('should display Email label', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('should display Password label', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should display Login button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Login'), findsWidgets);
    });

    testWidgets('should display Forgot Password button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('should display Register link', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('should display email icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('should display lock icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('should display password visibility toggle icon', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('should toggle password visibility when icon tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('should display or continue with divider', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('or continue with'), findsOneWidget);
    });
  });

  group('LoginScreen Form Validation', () {
    testWidgets('should show error when email is empty', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Login').last);
      await tester.pump();

      expect(find.text('Email cannot be empty'), findsOneWidget);
    });

    testWidgets('should show error when email is invalid', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'invalidemail');
      await tester.tap(find.text('Login').last);
      await tester.pump();

      expect(find.text('Enter a valid email ending with .com'), findsOneWidget);
    });

    testWidgets('should show error when password is empty', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.tap(find.text('Login').last);
      await tester.pump();

      expect(find.text('Password cannot be empty'), findsOneWidget);
    });

    testWidgets('should accept valid email input', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });
  });
}
