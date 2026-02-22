import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodify_food_delivery_system/features/profile/data/repositories/profile_repository.dart';
import 'package:foodify_food_delivery_system/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:foodify_food_delivery_system/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:foodify_food_delivery_system/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:foodify_food_delivery_system/features/profile/presentation/providers/profile_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockRepository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepository = MockProfileRepository();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        getProfileUseCaseProvider.overrideWithValue(
          GetProfileUseCase(mockRepository),
        ),
        updateProfileUseCaseProvider.overrideWithValue(
          UpdateProfileUseCase(mockRepository),
        ),
      ],
      child: const MaterialApp(home: EditProfilePage()),
    );
  }

  group('EditProfilePage UI Elements', () {
    testWidgets('should display Edit Profile title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text('Edit Profile'), findsOneWidget);
    });

    testWidgets('should display three text fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.byType(TextField), findsNWidgets(3));
    });

    testWidgets('should display Save Changes button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('should display camera icon for profile photo', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });

    testWidgets('should display person icon as default avatar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should show snackbar when saving with empty fields', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.tap(find.text('Save Changes'));
      await tester.pump();

      expect(find.text('Please fill all fields'), findsOneWidget);
    });
  });
}
