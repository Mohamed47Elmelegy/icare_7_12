import 'package:icare/core/di/injection_core.dart';
import 'package:icare/features/setting/data/data_sources/settings_remote_data_source.dart';
import 'package:icare/features/setting/data/repositories/settings_mode_repository.dart';
import 'package:icare/features/setting/domain/repositories/settings_repository.dart';

void initSettingsDependencies() {
  // Repositories
  sl.registerLazySingleton<SettingsRepository>(() => SettingsModelRepository(
        networkInfo: sl(),
        settingsRemoteDataSourceImpl: sl(),
      ));

  // DataSources
  sl.registerLazySingleton<SettingsRemoteDataSourceImpl>(
      () => SettingsRemoteDataSource(client: sl()));
}
