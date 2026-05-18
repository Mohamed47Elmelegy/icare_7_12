import 'package:icare/core/di/injection_core.dart';
import 'package:icare/features/authentication/data/data_sources/authentication_data_source.dart';
import 'package:icare/features/authentication/data/repositories/auth_service_model_repository.dart';
import 'package:icare/features/authentication/domain/repositories/auth_service_repository.dart';
import 'package:icare/features/authentication/domain/use_cases/login_user_usecase.dart';
import 'package:icare/features/authentication/domain/use_cases/register_user_usecase.dart';
import 'package:icare/features/authentication/domain/use_cases/social_login_user_usecase.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';

void initAuthDependencies() {
  // BLoC
  sl.registerLazySingleton(() => AuthBloc(
        loginUserServiceUseCase: sl(),
        registerUserServiceUseCase: sl(),
        socialUserServiceUseCase: sl(),
        appStartupCoordinator: sl(),
      ));

  // UseCases
  sl.registerLazySingleton(
      () => RegisterUserServiceUseCase(authServiceRepository: sl()));
  sl.registerLazySingleton(
      () => LoginUserServiceUseCase(authServiceRepository: sl()));
  sl.registerLazySingleton(
      () => SocialUserServiceUseCase(authServiceRepository: sl()));

  // Repositories
  sl.registerLazySingleton<AuthServiceRepository>(
      () => AuthServiceModelRepository(
            networkInfo: sl(),
            userServiceRemoteDataSource: sl(),
          ));

  // DataSources
  sl.registerLazySingleton<AuthServiceRemoteDataSource>(
      () => AuthServiceRemoteDataSource(dioClient: sl()));
}
