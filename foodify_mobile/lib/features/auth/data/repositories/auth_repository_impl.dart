// // import '../../domain/entities/user_entity.dart';
// // import '../../../auth/domain/repositories/auth_repositoty.dart';
// // import '../datasources/local/auth_local_datasource.dart';
// // import '../models/auth_hive_model.dart';

// // class AuthRepositoryImpl implements AuthRepository {
// //   final AuthLocalDataSource localDataSource;

// //   AuthRepositoryImpl({required this.localDataSource});

// //   @override
// //   Future<void> saveUser(UserEntity user) async {
// //     final model = AuthHiveModel(
// //       username: user.username,
// //       email: user.email,
// //       password: user.password,
// //     );
// //     await localDataSource.saveUser(model);
// //   }

// //   @override
// //   UserEntity? getUser(String email) {
// //     final model = localDataSource.getUser(email);
// //     if (model == null) return null;
// //     return UserEntity(
// //       username: model.username ?? '',
// //       email: model.email ?? '',
// //       password: model.password ?? '',
// //     );
// //   }
// // }

// import '../../domain/entities/user_entity.dart';
// import '../../domain/repositories/auth_repository.dart';
// import '../datasources/local/auth_local_datasource.dart';
// import '../datasources/remote/auth_remote_datasource.dart';
// import '../models/auth_api_model.dart';
// import '../models/auth_hive_model.dart';

// class AuthRepositoryImpl implements AuthRepository {
//   final AuthLocalDataSource localDataSource;
//   final AuthRemoteDataSource remoteDataSource;

//   AuthRepositoryImpl({
//     required this.localDataSource,
//     required this.remoteDataSource,
//   });

//   // API register
//   Future<AuthApiModel> registerApi(UserEntity user) async {
//     final body = {
//       "username": user.username,
//       "email": user.email,
//       "password": user.password,
//       "fullName": user.fullName,
//       "phone": user.phone,
//     };
//     return await remoteDataSource.register(body);
//   }

//   Future<AuthApiModel> loginApi(String email, String password) async {
//     return await remoteDataSource.login({"email": email, "password": password});
//   }

//   // Hive (optional)
//   @override
//   Future<void> saveUser(UserEntity user) async {
//     final model = AuthHiveModel(
//       username: user.username,
//       email: user.email,
//       password: user.password,
//     );
//     await localDataSource.saveUser(model);
//   }

//   @override
//   UserEntity? getUser(String email) {
//     final model = localDataSource.getUser(email);
//     if (model == null) return null;
//     return UserEntity(
//       username: model.username ?? '',
//       email: model.email ?? '',
//       password: model.password ?? '',
//       fullName: '',
//       phone: '',
//     );
//   }
// }

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart'; // MAKE SURE THIS IS HERE
import '../models/auth_api_model.dart';
import '../models/auth_hive_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override // ADD @override
  Future<AuthApiModel> registerApi(UserEntity user) async {
    final body = {
      "username": user.username,
      "email": user.email,
      "password": user.password,
      "fullName": user.fullName,
      "phone": user.phone,
    };
    return await remoteDataSource.register(body);
  }

  @override // ADD @override
  Future<AuthApiModel> loginApi(String email, String password) async {
    return await remoteDataSource.login({"email": email, "password": password});
  }

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
      fullName: '', // Now this will work
      phone: '', // Now this will work
    );
  }
}
