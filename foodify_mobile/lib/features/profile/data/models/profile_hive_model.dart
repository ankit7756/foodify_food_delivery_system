import 'package:hive/hive.dart';
import '../../../../core/constants/hive_table_constants.dart';
import '../../domain/entities/user_profile_entity.dart';

part 'profile_hive_model.g.dart';

@HiveType(typeId: HiveTableConstants.profileTypeId)
class ProfileHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String phone;

  @HiveField(5)
  final String? profileImage;

  @HiveField(6)
  final String role;

  ProfileHiveModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.role,
  });

  factory ProfileHiveModel.fromEntity(UserProfileEntity entity) {
    return ProfileHiveModel(
      id: entity.id,
      fullName: entity.fullName,
      username: entity.username,
      email: entity.email,
      phone: entity.phone,
      profileImage: entity.profileImage,
      role: entity.role,
    );
  }

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: id,
      fullName: fullName,
      username: username,
      email: email,
      phone: phone,
      profileImage: profileImage,
      role: role,
    );
  }
}
