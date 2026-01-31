import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodify_food_delivery_system/features/profile/presentation/pages/profile_page.dart';

void main() {
  group('ProfilePage Widget Tests', () {
    testWidgets('should display Profile title in AppBar', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfilePage())),
      );

      // Assert
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display refresh button in AppBar', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfilePage())),
      );

      // Assert
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should display profile icon when no image is loaded', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfilePage())),
      );
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.person), findsWidgets);
    });

    testWidgets('should display Edit Profile button', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfilePage())),
      );
      await tester.pump();

      // Assert
      expect(
        find.widgetWithText(ElevatedButton, 'Edit Profile'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('should display menu items', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfilePage())),
      );
      await tester.pump();

      // Assert
      expect(find.text('Delivery Address'), findsOneWidget);
      expect(find.text('Payment Methods'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Help & Support'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('should display menu item icons', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfilePage())),
      );
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
      expect(find.byIcon(Icons.payment_outlined), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      expect(find.byIcon(Icons.help_outline), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('should display ListTile widgets for menu items', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfilePage())),
      );
      await tester.pump();

      // Assert
      expect(find.byType(ListTile), findsNWidgets(6)); // 6 menu items
    });

    testWidgets(
      'should show logout confirmation dialog when logout is tapped',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: ProfilePage())),
        );
        await tester.pump();

        // Act
        final logoutTile = find.text('Logout');
        await tester.tap(logoutTile);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Are you sure you want to logout?'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      },
    );

    testWidgets('should have RefreshIndicator for pull-to-refresh', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfilePage())),
      );

      // Assert
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('should display SingleChildScrollView', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfilePage())),
      );

      // Assert
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
