import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_food_delivery_system/features/auth/data/models/auth_api_model.dart';

void main() {
  group('AuthApiModel Tests', () {
    test('should correctly parse JSON from API response with all fields', () {
      // Arrange
      final json = {
        'message': 'Login successful',
        'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
        'user': {
          '_id': '507f1f77bcf86cd799439011',
          'username': 'johndoe',
          'email': 'john@example.com',
          'fullName': 'John Doe',
          'phone': '9876543210',
        },
      };

      // Act
      final model = AuthApiModel.fromJson(json);

      // Assert
      expect(model.message, 'Login successful');
      expect(model.token, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9');
      expect(model.id, '507f1f77bcf86cd799439011');
      expect(model.username, 'johndoe');
      expect(model.email, 'john@example.com');
      expect(model.fullName, 'John Doe');
      expect(model.phone, '9876543210');
    });

    test('should handle JSON with missing optional fields', () {
      // Arrange
      final json = {'message': 'Registration successful'};

      // Act
      final model = AuthApiModel.fromJson(json);

      // Assert
      expect(model.message, 'Registration successful');
      expect(model.token, isNull);
      expect(model.id, isNull);
      expect(model.username, isNull);
      expect(model.email, isNull);
      expect(model.fullName, isNull);
      expect(model.phone, isNull);
    });

    test('should handle empty user object in JSON', () {
      // Arrange
      final json = {'message': 'Success', 'token': 'abc123', 'user': {}};

      // Act
      final model = AuthApiModel.fromJson(json);

      // Assert
      expect(model.message, 'Success');
      expect(model.token, 'abc123');
      expect(model.id, isNull);
      expect(model.username, isNull);
      expect(model.email, isNull);
    });

    test('should create AuthApiModel using constructor', () {
      // Arrange & Act
      final model = AuthApiModel(
        message: 'Test message',
        token: 'test_token',
        id: 'test_id',
        username: 'testuser',
        email: 'test@test.com',
        fullName: 'Test User',
        phone: '1234567890',
      );

      // Assert
      expect(model.message, 'Test message');
      expect(model.token, 'test_token');
      expect(model.id, 'test_id');
      expect(model.username, 'testuser');
      expect(model.email, 'test@test.com');
      expect(model.fullName, 'Test User');
      expect(model.phone, '1234567890');
    });

    test('should handle JSON without user field', () {
      // Arrange
      final json = {'message': 'Error occurred', 'token': null};

      // Act
      final model = AuthApiModel.fromJson(json);

      // Assert
      expect(model.message, 'Error occurred');
      expect(model.token, isNull);
      expect(model.username, isNull);
    });
  });
}
