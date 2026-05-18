import 'package:icare/core/di/injection_core.dart';
import 'package:icare/features/locations/data/data_sources/location_remote_data_source.dart';
import 'package:icare/features/locations/data/repositories/locations_model_repository.dart';
import 'package:icare/features/locations/domain/repositories/location_repository.dart';
import 'package:icare/features/locations/domain/use_cases/locations_usecase.dart';
import 'package:icare/features/locations/presentation/bloc/locations_bloc.dart';

void initLocationsDependencies() {
  // BLoC
  sl.registerLazySingleton(() => LocationsBloc(
        fetchUserLocationsUseCase: sl(),
        addLocationUseCase: sl(),
        removeLocationUseCase: sl(),
        updateLocationUseCase: sl(),
      ));

  // UseCases
  sl.registerLazySingleton(
      () => FetchUserLocationsUseCase(locationsRepository: sl()));
  sl.registerLazySingleton(() => AddLocationUseCase(locationsRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateLocationUseCase(locationsRepository: sl()));
  sl.registerLazySingleton(
      () => RemoveLocationUseCase(locationsRepository: sl()));

  // Repositories
  sl.registerLazySingleton<LocationsRepository>(() => LocationsModelRepository(
        networkInfo: sl(),
        locationRemoteDataSource: sl(),
      ));

  // DataSources
  sl.registerLazySingleton<LocationRemoteDataSourceImpl>(
      () => LocationRemoteDataSource(client: sl()));
}
