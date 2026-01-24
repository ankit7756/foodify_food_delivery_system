import '../entities/user_entity.dart';
import '../../data/models/auth_api_model.dart'; // ADD THIS IMPORT

abstract class AuthRepository {
  // API methods
  Future<AuthApiModel> registerApi(UserEntity user);
  Future<AuthApiModel> loginApi(String email, String password);

  // Local Hive methods
  Future<void> saveUser(UserEntity user);
  UserEntity? getUser(String email);
}
