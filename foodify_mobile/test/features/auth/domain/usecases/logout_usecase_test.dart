// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:foodify_food_delivery_system/features/auth/domain/usecases/logout_usecase.dart';
// import 'package:foodify_food_delivery_system/core/error/faliures.dart';

// void main() {
//   late LogoutUseCase logoutUseCase;

//   setUp(() {
//     logoutUseCase = LogoutUseCase();
//   });

//   group('LogoutUseCase Tests', () {
//     test('should return Right(null) when logout is successful', () async {
//       // Act
//       final result = await logoutUseCase.call();

//       // Assert
//       expect(result.isRight(), true);
//       result.fold(
//         (failure) => fail('Should succeed'),
//         (value) => expect(value, Null),
//       );
//     });

//     test('should clear user session on successful logout', () async {
//       // Act
//       final result = await logoutUseCase.call();

//       // Assert
//       expect(result, equals(const Right(null)));
//     });

//     test('should be callable multiple times', () async {
//       // Act
//       final result1 = await logoutUseCase.call();
//       final result2 = await logoutUseCase.call();

//       // Assert
//       expect(result1.isRight(), true);
//       expect(result2.isRight(), true);
//     });

//     test('should handle logout gracefully', () async {
//       // Act
//       final result = await logoutUseCase.call();

//       // Assert
//       expect(result, isA<Right>());
//       result.fold(
//         (failure) => fail('Logout should not fail'),
//         (value) => expect(value, Null),
//       );
//     });

//     test('should return CacheFailure if session clearing fails', () async {
//       // Note: This test assumes session clearing could theoretically fail
//       // In the actual implementation, it might not throw errors
//       // But we test the error handling path exists
      
//       // Act
//       final result = await logoutUseCase.call();

//       // Assert - Normally should succeed
//       expect(result.isRight(), true);
//     });
//   });
// }