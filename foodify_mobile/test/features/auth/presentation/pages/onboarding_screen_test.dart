import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../../lib/features/onboarding/presentation/pages/onboarding_screen.dart';

void main() {
  group('OnboardingScreen Widget Tests', () {
    testWidgets('should display skip button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      // Assert
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('should display first onboarding page', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      // Assert
      expect(find.text('Find Delicious Food'), findsOneWidget);
      expect(
        find.text(
          'Explore restaurants near you and order your favorite dishes in seconds.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display Next button on first page', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      // Assert
      expect(find.widgetWithText(ElevatedButton, 'Next'), findsOneWidget);
    });

    testWidgets('should display page indicators (dots)', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      // Assert - Should have 3 dots for 3 pages
      final dotContainers = find.byType(AnimatedContainer);
      expect(dotContainers, findsWidgets);
    });

    testWidgets('should navigate to next page when Next button is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      // Act
      final nextButton = find.widgetWithText(ElevatedButton, 'Next');
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Assert - Should show second page
      expect(find.text('Fast Delivery'), findsOneWidget);
      expect(
        find.text(
          'Get your food delivered hot and fresh with real-time tracking.',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'should display Get Started button on last page after navigation',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

        // Act - Navigate to last page
        final nextButton = find.widgetWithText(ElevatedButton, 'Next');
        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.widgetWithText(ElevatedButton, 'Get Started'),
          findsOneWidget,
        );
        expect(find.text('Secure Payment'), findsOneWidget);
      },
    );

    testWidgets('should display icons for each page', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      // Assert
      expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);

      // Navigate to second page
      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.delivery_dining), findsOneWidget);

      // Navigate to third page
      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.payment), findsOneWidget);
    });

    testWidgets('should have PageView widget', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));

      // Assert
      expect(find.byType(PageView), findsOneWidget);
    });
  });
}
