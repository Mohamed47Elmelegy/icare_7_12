import 'package:icare/core/di/injection_core.dart';
import 'package:icare/features/nurse/data/data_sources/nurse_remote_data_source.dart';
import 'package:icare/features/nurse/data/repositories/nurse_model_repository.dart';
import 'package:icare/features/nurse/domain/repositories/nurse_repository.dart';
import 'package:icare/features/nurse/domain/use_cases/get_all_nurses_usecase.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';

void initNurseDependencies() {
  // BLoC
  sl.registerLazySingleton(
      () => NurseBloc(getAllNursesUseCase: sl(), rateNurseUseCase: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetAllNursesUseCase(nurseRepository: sl()));
  sl.registerLazySingleton(() => RateNurseUseCase(nurseRepository: sl()));

  // Repositories
  sl.registerLazySingleton<NursesRepository>(() => NursesModelRepository(
        networkInfo: sl(),
        nursesRemoteDataSourceImpl: sl(),
      ));

  // DataSources
  sl.registerLazySingleton<NursesRemoteDataSourceImpl>(
      () => NursesRemoteDataSource(client: sl()));
}
