import 'package:dartz/dartz.dart';
import '../../../../core/error/faliures.dart';
import '../../../../core/storage/user_session_service.dart';

class LogoutUseCase {
  Future<Either<Failure, void>> call() async {
    try {
      await UserSessionService.clearSession();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
