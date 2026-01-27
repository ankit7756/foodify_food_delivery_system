import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../entities/user_profile_entity.dart';
import '../../data/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserProfileEntity>> call({
    required String token,
    required String fullName,
    required String username,
    required String phone,
    File? profileImage,
  }) async {
    return await repository.updateProfile(
      token: token,
      fullName: fullName,
      username: username,
      phone: phone,
      profileImage: profileImage,
    );
  }
}
