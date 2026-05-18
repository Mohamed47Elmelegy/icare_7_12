import 'package:icare/core/di/injection_core.dart';
import 'package:icare/features/doctor/data/data_sources/doctor_remote_data_source.dart';
import 'package:icare/features/doctor/data/repositories/doctor_model_repository.dart';
import 'package:icare/features/doctor/domain/repositories/doctor_repository.dart';
import 'package:icare/features/doctor/domain/use_cases/get_all_doctors_usecase.dart';
import 'package:icare/features/doctor/presentation/bloc/doctors_bloc.dart';

void initDoctorDependencies() {
  // BLoC
  sl.registerLazySingleton(
      () => DoctorBloc(getAllDoctorsUseCase: sl(), rateDoctorUseCase: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetAllDoctorsUseCase(doctorRepository: sl()));
  sl.registerLazySingleton(() => RateDoctorUseCase(doctorRepository: sl()));

  // Repositories
  sl.registerLazySingleton<DoctorsRepository>(() => DoctorsModelRepository(
        networkInfo: sl(),
        doctorsRemoteDataSourceImpl: sl(),
      ));

  // DataSources
  sl.registerLazySingleton<DoctorsRemoteDataSourceImpl>(
      () => DoctorsRemoteDataSource(client: sl()));
}
