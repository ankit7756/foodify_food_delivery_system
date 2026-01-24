import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/models/auth_api_model.dart';

class AuthUseCases {
  final AuthRepository repository;

  AuthUseCases({required this.repository});

  Future<AuthApiModel> registerUser(UserEntity user) async {
    return await repository.registerApi(user);
  }

  Future<AuthApiModel> loginUser(String email, String password) async {
    return await repository.loginApi(email, password);
  }
}

class SaveUserUseCase {
  final AuthRepository repository;

  SaveUserUseCase(this.repository);

  Future<void> call(UserEntity user) async {
    await repository.saveUser(user);
  }
}

class GetUserUseCase {
  final AuthRepository repository;

  GetUserUseCase(this.repository);

  UserEntity? call(String email) {
    return repository.getUser(email);
  }
}
