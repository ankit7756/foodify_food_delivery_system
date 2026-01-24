import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../../../../core/storage/user_session_service.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(
    String email,
    String password,
  ) async {
    try {
      final response = await repository.loginApi(email, password);

      // Save token and email to session
      if (response.token != null) {
        await UserSessionService.saveToken(response.token!);
        await UserSessionService.saveEmail(email);
      }

      // Convert AuthApiModel to UserEntity
      final user = UserEntity(
        username: response.username ?? '',
        email: response.email ?? email,
        password: '', // Don't store password
        fullName: response.fullName ?? '',
        phone: response.phone ?? '',
      );

      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
