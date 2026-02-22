import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/usecases/logout_usecase.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/usecases/register_usecase.dart';
import 'package:foodify_food_delivery_system/features/auth/presentation/pages/register_screen.dart';
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
      child: const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(800, 1400)), // ✅ taller viewport
          child: RegisterScreen(),
        ),
      ),
    );
  }

  group('RegisterScreen UI Elements', () {
    testWidgets('should display Create Account text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('should display Sign up to get started text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Sign up to get started'), findsOneWidget);
    });

    testWidgets('should display all five input fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(TextField), findsNWidgets(5));
    });

    testWidgets('should display Register button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('should display Login link', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should display Already have an account text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Already have an account? '), findsOneWidget);
    });
  });

  group('RegisterScreen Form Validation', () {
    testWidgets('should show error when username is empty', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pump();
      await tester.tap(find.text('Register'));
      await tester.pump();
      expect(find.text('Username cannot be empty'), findsOneWidget);
    });

    testWidgets('should show error when email is invalid', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextField).at(0), 'testuser');
      await tester.enterText(find.byType(TextField).at(1), 'bademail');
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pump();
      await tester.tap(find.text('Register'));
      await tester.pump();
      expect(find.text('Enter a valid email ending with .com'), findsOneWidget);
    });

    testWidgets('should show error when password is too short', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextField).at(0), 'testuser');
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), '123');
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pump();
      await tester.tap(find.text('Register'));
      await tester.pump();
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('should show error when phone is invalid', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextField).at(0), 'testuser');
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), 'password123');
      await tester.enterText(find.byType(TextField).at(3), 'Test User');
      await tester.enterText(find.byType(TextField).at(4), '123');
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pump();
      await tester.tap(find.text('Register'));
      await tester.pump();
      expect(
        find.text('Enter a valid phone number (10+ digits)'),
        findsOneWidget,
      );
    });

    testWidgets('should toggle password visibility', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });
  });
}
