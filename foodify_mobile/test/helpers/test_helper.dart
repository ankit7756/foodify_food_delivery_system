import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Helper function to wrap widgets with MaterialApp and ProviderScope for testing
Widget createTestWidget(Widget child) {
  return ProviderScope(child: MaterialApp(home: child));
}

/// Helper function to create a widget with custom providers
Widget createTestWidgetWithProviders(Widget child, List<Override> overrides) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(home: child),
  );
}

/// Helper function to pump widget with common setup
Future<void> pumpTestWidget(WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(createTestWidget(widget));
}

/// Helper to find text field by label
Finder findTextFieldByLabel(String label) {
  return find.widgetWithText(TextField, label);
}

/// Helper to enter text in field
Future<void> enterTextInField(
  WidgetTester tester,
  String label,
  String text,
) async {
  final field = findTextFieldByLabel(label);
  await tester.enterText(field, text);
  await tester.pump();
}

/// Helper to tap button and wait
Future<void> tapButtonAndSettle(WidgetTester tester, String buttonText) async {
  final button = find.widgetWithText(ElevatedButton, buttonText);
  await tester.tap(button);
  await tester.pumpAndSettle();
}
