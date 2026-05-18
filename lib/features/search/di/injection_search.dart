import 'package:icare/core/di/injection_core.dart';
import 'package:icare/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:icare/features/search/data/repositories/search_repository_impl.dart';
import 'package:icare/features/search/domain/repositories/search_repository.dart';
import 'package:icare/features/search/domain/use_cases/search_by_service_usecase.dart';
import 'package:icare/features/search/presentation/bloc/search_bloc.dart';

void initSearchDependencies() {
  // BLoC
  sl.registerLazySingleton(() => SearchBloc(searchByServiceUseCase: sl()));

  // UseCases
  sl.registerLazySingleton(
      () => SearchByServiceUseCase(searchRepository: sl()));

  // Repositories
  sl.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  // DataSources
  sl.registerLazySingleton<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(client: sl()));
}
