import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_food_delivery_system/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestWidget() {
    return const MaterialApp(home: OnboardingScreen());
  }

  group('OnboardingScreen UI Elements', () {
    testWidgets('should display Skip button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('should display Next button on first page', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('should display first page title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Find Delicious Food'), findsOneWidget);
    });

    testWidgets('should display first page subtitle', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(
        find.text(
          'Explore restaurants near you and order your favorite dishes in seconds.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display PageView', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('should show Get Started on last page after swiping', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.drag(find.byType(PageView), const Offset(-800, 0));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(PageView), const Offset(-800, 0));
      await tester.pumpAndSettle();

      expect(find.text('Get Started'), findsOneWidget);
    });
  });
}
