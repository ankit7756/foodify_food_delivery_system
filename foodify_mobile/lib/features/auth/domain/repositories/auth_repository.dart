// // import '../entities/user_entity.dart';

// // abstract class AuthRepository {
// //   Future<void> saveUser(UserEntity user);
// //   UserEntity? getUser(String email);
// // }

// // import '../../domain/entities/user_entity.dart';
// // import '../../domain/repositories/auth_repository.dart';
// // import '../../data/models/auth_api_model.dart';

// // class AuthUseCases {
// //   final AuthRepository repository;

// //   AuthUseCases({required this.repository});

// //   Future<AuthApiModel> registerUser(UserEntity user) async {
// //     return await repository.registerApi(user);
// //   }

// //   Future<AuthApiModel> loginUser(String email, String password) async {
// //     return await repository.loginApi(email, password);
// //   }
// // }

// import '../entities/user_entity.dart';
// import '../../data/models/auth_api_model.dart';

// abstract class AuthRepository {
//   // API methods
//   Future<AuthApiModel> registerApi(UserEntity user);
//   Future<AuthApiModel> loginApi(String email, String password);

//   // Local Hive methods
//   Future<void> saveUser(UserEntity user);
//   UserEntity? getUser(String email);
// }

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
