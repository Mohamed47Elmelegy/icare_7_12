import 'package:icare/core/di/injection_core.dart';
import 'package:icare/features/account/data/data_sources/account_data_source.dart';
import 'package:icare/features/account/data/data_sources/medical_reports_remote_data_source.dart';
import 'package:icare/features/account/data/repositeroies/user_service_model_repository.dart';
import 'package:icare/features/account/data/repositories/medical_reports_repository_impl.dart';
import 'package:icare/features/account/domain/repositories/medical_reports_repository.dart';
import 'package:icare/features/account/domain/repositories/user_service_repository.dart';
import 'package:icare/features/account/domain/use_cases/change_password_usercase.dart';
import 'package:icare/features/account/domain/use_cases/delete_account_usecase.dart';
import 'package:icare/features/account/domain/use_cases/get_all_users_usecase.dart';
import 'package:icare/features/account/domain/use_cases/get_services_usecase.dart';
import 'package:icare/features/account/domain/use_cases/get_user_service_usecase.dart';
import 'package:icare/features/account/domain/use_cases/update_doctor_options_usecase.dart';
import 'package:icare/features/account/domain/use_cases/update_nurse_options_usecase.dart';
import 'package:icare/features/account/domain/use_cases/update_user_usecase.dart';
import 'package:icare/features/account/domain/usecases/create_medical_report_usecase.dart';
import 'package:icare/features/account/domain/usecases/get_patient_medical_reports_usecase.dart';
import 'package:icare/features/account/domain/use_cases/get_user_full_data_usecase.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/services_bloc.dart';
import 'package:icare/features/setting/domain/use_cases/get_specialties_usecase.dart';
import 'package:icare/features/setting/domain/use_cases/notifications_usecase.dart';

void initAccountDependencies() {
  // BLoC
  sl.registerLazySingleton(() => AccountBloc(
      getUserServiceUseCase: sl(),
      updateUserServiceUseCase: sl(),
      changePasswordUseCase: sl(),
      getAllUsersUseCase: sl(),
      updateProfileStatusUseCase: sl(),
      getUserFullDataUseCase: sl(),
      createMedicalReportUseCase: sl(),
      getPatientMedicalReportsUseCase: sl(),
      updateNurseOptionsUseCase: sl(),
      updateDoctorOptionsUseCase: sl(),
      deleteAccountUseCase: sl()));

  sl.registerLazySingleton(() => ServicesBloc(
      getServicesUseCase: sl(),
      getSpecialtiesUseCase: sl(),
      updateNurseOptionsUseCase: sl(),
      updateDoctorOptionsUseCase: sl(),
      getAllNotificationsUseCase: sl()));

  // UseCases
  sl.registerLazySingleton(
      () => GetAllUsersUseCase(userServiceRepository: sl()));
  sl.registerLazySingleton(
      () => GetUserServiceUseCase(userServiceRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateUserServiceUseCase(userServiceRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateProfileStatusUseCase(userServiceRepository: sl()));
  sl.registerLazySingleton(() => GetUserFullDataUseCase(repository: sl()));
  sl.registerLazySingleton(
      () => ChangePasswordUseCase(userServiceRepository: sl()));
  sl.registerLazySingleton(
      () => GetAllNotificationsUseCase(settingsRepository: sl()));
  sl.registerLazySingleton(() => CreateMedicalReportUseCase(repository: sl()));
  sl.registerLazySingleton(
      () => GetPatientMedicalReportsUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateNurseOptionsUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateDoctorOptionsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetServicesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetSpecialtiesUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(repository: sl()));

  // Repositories
  sl.registerLazySingleton<UserServiceRepository>(
      () => UserServiceModelRepository(
            networkInfo: sl(),
            userServiceRemoteDataSource: sl(),
          ));
  sl.registerLazySingleton<MedicalReportsRepository>(
      () => MedicalReportsRepositoryImpl(remoteDataSource: sl()));

  // DataSources
  sl.registerLazySingleton<UserServiceRemoteDataSource>(
      () => UserServiceRemoteDataSource(client: sl()));
  sl.registerLazySingleton<MedicalReportsRemoteDataSource>(
      () => MedicalReportsRemoteDataSourceImpl(client: sl()));
}
