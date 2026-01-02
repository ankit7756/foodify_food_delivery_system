import '../entities/user_entity.dart';
import '../../domain/repositories/auth_repositoty.dart';

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
