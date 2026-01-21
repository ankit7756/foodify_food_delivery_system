// import 'package:hive/hive.dart';
// import '../../../../../core/services/hive/hive_service.dart';
// import '../../models/auth_hive_model.dart';
// import '../../../../../core/constants/hive_table_constants.dart';

// class AuthLocalDataSource {
//   final Box<AuthHiveModel> _userBox = HiveService.getUserBox();

//   Future<void> saveUser(AuthHiveModel user) async {
//     await _userBox.put(user.email, user);
//   }

//   AuthHiveModel? getUser(String email) {
//     return _userBox.get(email);
//   }

//   Future<void> clearAllUsers() async {
//     await _userBox.clear();
//   }
// }

import 'package:hive/hive.dart';
import '../../../../../core/services/hive/hive_service.dart';
import '../../models/auth_hive_model.dart';

class AuthLocalDataSource {
  // Remove the final _userBox line

  Future<void> saveUser(AuthHiveModel user) async {
    final box = HiveService.getUserBox(); // Get when needed
    await box.put(user.email, user);
  }

  AuthHiveModel? getUser(String email) {
    final box = HiveService.getUserBox(); // Get when needed
    return box.get(email);
  }

  Future<void> clearAllUsers() async {
    final box = HiveService.getUserBox();
    await box.clear();
  }
}
