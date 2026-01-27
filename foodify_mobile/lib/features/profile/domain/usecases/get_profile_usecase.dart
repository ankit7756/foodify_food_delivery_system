import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../entities/user_profile_entity.dart';
import '../../data/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, UserProfileEntity>> call(String token) async {
    return await repository.getProfile(token);
  }
}
