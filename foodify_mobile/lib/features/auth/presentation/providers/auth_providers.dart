import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

// Data Sources
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource();
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ApiClient(baseUrl: ApiConfig.baseUrl);
  return AuthRemoteDataSource(client: apiClient);
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final localDataSource = ref.read(authLocalDataSourceProvider);
  final remoteDataSource = ref.read(authRemoteDataSourceProvider);

  return AuthRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

// Use Cases
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LoginUseCase(repository);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return RegisterUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase();
});
