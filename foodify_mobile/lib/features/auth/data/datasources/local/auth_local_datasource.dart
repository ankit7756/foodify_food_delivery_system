import 'package:hive/hive.dart';
import '../../../../../core/services/hive/hive_service.dart';
import '../../models/auth_hive_model.dart';

class AuthLocalDataSource {
  Future<void> saveUser(AuthHiveModel user) async {
    final box = HiveService.getUserBox();
    await box.put(user.email, user);
  }

  AuthHiveModel? getUser(String email) {
    final box = HiveService.getUserBox();
    return box.get(email);
  }

  Future<void> clearAllUsers() async {
    final box = HiveService.getUserBox();
    await box.clear();
  }
}
