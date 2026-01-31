import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_food_delivery_system/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserEntity Tests', () {
    test('should create UserEntity with all required fields', () {
      // Arrange
      const username = 'johndoe';
      const email = 'john@example.com';
      const password = 'password123';
      const fullName = 'John Doe';
      const phone = '9876543210';

      // Act
      final user = UserEntity(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );

      // Assert
      expect(user.username, username);
      expect(user.email, email);
      expect(user.password, password);
      expect(user.fullName, fullName);
      expect(user.phone, phone);
    });

    test('should have correct values assigned to properties', () {
      // Arrange & Act
      final user = UserEntity(
        username: 'testuser',
        email: 'test@gmail.com',
        password: 'test123',
        fullName: 'Test User',
        phone: '1234567890',
      );

      // Assert
      expect(user.username, isNotEmpty);
      expect(user.email, contains('@'));
      expect(user.password, isNotEmpty);
      expect(user.fullName, isNotEmpty);
      expect(user.phone, hasLength(10));
    });

    test('should allow creating different user instances', () {
      // Arrange & Act
      final user1 = UserEntity(
        username: 'user1',
        email: 'user1@test.com',
        password: 'pass1',
        fullName: 'User One',
        phone: '1111111111',
      );

      final user2 = UserEntity(
        username: 'user2',
        email: 'user2@test.com',
        password: 'pass2',
        fullName: 'User Two',
        phone: '2222222222',
      );

      // Assert
      expect(user1.username, isNot(equals(user2.username)));
      expect(user1.email, isNot(equals(user2.email)));
    });
  });
}
