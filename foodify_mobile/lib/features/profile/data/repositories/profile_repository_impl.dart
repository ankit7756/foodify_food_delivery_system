import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';
import '../datasources/remote/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserProfileEntity>> getProfile(String token) async {
    try {
      final profile = await remoteDataSource.getProfile(token);
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateProfile({
    required String token,
    required String fullName,
    required String username,
    required String phone,
    File? profileImage,
  }) async {
    try {
      final profile = await remoteDataSource.updateProfile(
        token: token,
        fullName: fullName,
        username: username,
        phone: phone,
        profileImage: profileImage,
      );
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
