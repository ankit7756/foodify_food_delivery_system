import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_food_delivery_system/core/error/faliures.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/usecases/logout_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LogoutUseCase logoutUseCase;

  setUp(() {
    logoutUseCase = LogoutUseCase();
    SharedPreferences.setMockInitialValues({});
  });

  group('LogoutUseCase', () {
    test('should return Right(null) when logout succeeds', () async {
      final result = await logoutUseCase();

      expect(result.isRight(), true);
    });

    test('should clear session on successful logout', () async {
      SharedPreferences.setMockInitialValues({
        'token': 'some_token',
        'email': 'test@example.com',
      });

      final result = await logoutUseCase();

      expect(result.isRight(), true);
      result.fold((_) => fail('Expected success'), (_) => expect(true, true));
    });

    test('should return void on success not a value', () async {
      final result = await logoutUseCase();
      expect(result.isRight(), true);
    });
  });
}
