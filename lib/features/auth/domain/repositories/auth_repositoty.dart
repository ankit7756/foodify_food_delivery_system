import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> saveUser(UserEntity user);
  UserEntity? getUser(String email);
}
