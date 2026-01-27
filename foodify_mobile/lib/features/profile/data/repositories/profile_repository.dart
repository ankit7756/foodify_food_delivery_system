import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../../domain/entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getProfile(String token);
  Future<Either<Failure, UserProfileEntity>> updateProfile({
    required String token,
    required String fullName,
    required String username,
    required String phone,
    File? profileImage,
  });
}
