import 'package:hive/hive.dart';
part 'auth_hive_model.g.dart';

@HiveType(typeId: 0)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  String? username;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? password;

  AuthHiveModel({this.username, this.email, this.password});
}
