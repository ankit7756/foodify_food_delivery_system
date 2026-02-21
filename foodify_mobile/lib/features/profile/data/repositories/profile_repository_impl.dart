import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';
import '../datasources/remote/profile_remote_datasource.dart';
import '../datasources/local/profile_local_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Future<Either<Failure, UserProfileEntity>> getProfile(String token) async {
    if (await _isOnline()) {
      try {
        final profile = await remoteDataSource.getProfile(token);
        await localDataSource.cacheProfile(profile);
        return Right(profile);
      } catch (e) {
        final cached = localDataSource.getCachedProfile();
        if (cached != null) return Right(cached);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      final cached = localDataSource.getCachedProfile();
      if (cached != null) return Right(cached);
      return Left(ServerFailure('No internet connection.'));
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
      if (!await _isOnline()) {
        return Left(
          ServerFailure(
            'No internet connection. Cannot update profile offline.',
          ),
        );
      }
      final profile = await remoteDataSource.updateProfile(
        token: token,
        fullName: fullName,
        username: username,
        phone: phone,
        profileImage: profileImage,
      );
      // Update cache with new profile
      await localDataSource.cacheProfile(profile);
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
