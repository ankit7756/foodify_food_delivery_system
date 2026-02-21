import '../../../../../core/services/hive/hive_service.dart';
import '../../models/profile_hive_model.dart';
import '../../../domain/entities/user_profile_entity.dart';

class ProfileLocalDataSource {
  Future<void> cacheProfile(UserProfileEntity profile) async {
    final model = ProfileHiveModel.fromEntity(profile);
    await HiveService.saveProfile(model);
  }

  UserProfileEntity? getCachedProfile() {
    final model = HiveService.getCachedProfile();
    return model?.toEntity();
  }

  bool hasCachedProfile() {
    return HiveService.getCachedProfile() != null;
  }
}
