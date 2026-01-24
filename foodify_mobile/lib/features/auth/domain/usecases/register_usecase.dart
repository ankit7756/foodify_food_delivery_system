import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, String>> call(UserEntity user) async {
    try {
      final response = await repository.registerApi(user);
      return Right(response.message);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
