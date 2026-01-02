import '../../domain/entities/user_entity.dart';
import '../../../auth/domain/repositories/auth_repositoty.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../models/auth_hive_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveUser(UserEntity user) async {
    final model = AuthHiveModel(
      username: user.username,
      email: user.email,
      password: user.password,
    );
    await localDataSource.saveUser(model);
  }

  @override
  UserEntity? getUser(String email) {
    final model = localDataSource.getUser(email);
    if (model == null) return null;
    return UserEntity(
      username: model.username ?? '',
      email: model.email ?? '',
      password: model.password ?? '',
    );
  }
}
