import 'package:icare/core/di/injection_core.dart';
import 'package:icare/features/categories/data/data_sources/category_remote_data_source.dart';
import 'package:icare/features/categories/data/repositories/category_model_repository.dart';
import 'package:icare/features/categories/domain/repositories/category_repository.dart';
import 'package:icare/features/categories/domain/use_cases/get_all_categories_usecase.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_bloc.dart';

void initCategoriesDependencies() {
  // BLoC
  sl.registerLazySingleton(() => CategoriesBloc(
      getAllCategoryUseCase: sl(),
      getAllSlidersUseCase: sl(),
      getAllAllergiesUseCase: sl(),
      getAllPublicationsUseCase: sl()));

  // UseCases
  sl.registerLazySingleton(
      () => GetAllCategoryUseCase(categoryRepository: sl()));
  sl.registerLazySingleton(
      () => GetAllAllergiesUseCase(categoryRepository: sl()));
  sl.registerLazySingleton(
      () => GetPatientAllergiesUseCase(categoryRepository: sl()));
  sl.registerLazySingleton(
      () => GetAllSlidersUseCase(categoryRepository: sl()));
  sl.registerLazySingleton(
      () => GetAllPublicationsUseCase(categoryRepository: sl()));

  // Repositories
  sl.registerLazySingleton<CategoryRepository>(() => CategoryModelRepository(
        networkInfo: sl(),
        categoryRemoteDataSource: sl(),
      ));

  // DataSources
  sl.registerLazySingleton<CategoryRemoteDataSourceImpl>(
      () => CategoryRemoteDataSource(client: sl()));
}
