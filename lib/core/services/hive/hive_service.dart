// import 'package:hive_flutter/hive_flutter.dart';
// import '../../constants/hive_table_constants.dart';
// import '../../../features/auth/data/models/auth_hive_model.dart';

// class HiveService {
//   static Future<void> initHive() async {
//     await Hive.initFlutter();
//     Hive.registerAdapter(AuthHiveModelAdapter());
//     await Hive.openBox<AuthHiveModel>(HiveTableConstants.userTable);
//   }

//   static Box<AuthHiveModel> getUserBox() {
//     return Hive.box<AuthHiveModel>(HiveTableConstants.userTable);
//   }

//   static Future<void> openUserBox() async {}
// }
import 'package:hive_flutter/hive_flutter.dart';
import '../../constants/hive_table_constants.dart';
import '../../../features/auth/data/models/auth_hive_model.dart';

class HiveService {
  static Future<void> initHive() async {
    await Hive.initFlutter();

    // Register adapter if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }

    // Open box if not already open
    if (!Hive.isBoxOpen(HiveTableConstants.userTable)) {
      await Hive.openBox<AuthHiveModel>(HiveTableConstants.userTable);
    }
  }

  static Box<AuthHiveModel> getUserBox() {
    if (!Hive.isBoxOpen(HiveTableConstants.userTable)) {
      throw HiveError('Box is not open. Call initHive() first.');
    }
    return Hive.box<AuthHiveModel>(HiveTableConstants.userTable);
  }
}
