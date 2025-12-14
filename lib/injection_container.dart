part of 'injection_container_import.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //controller
  sl.registerFactory(() => RootBloc());

  /// authentication bloc and classes initial
  sl.registerFactory(() => AuthBloc(
        loginUserServiceUseCase: sl(),
        registerUserServiceUseCase: sl(),
        socialUserServiceUseCase: sl(),
      ));

  sl.registerLazySingleton(
      () => RegisterUserServiceUseCase(authServiceRepository: sl()));
  sl.registerLazySingleton(
      () => LoginUserServiceUseCase(authServiceRepository: sl()));
  sl.registerLazySingleton(
      () => SocialUserServiceUseCase(authServiceRepository: sl()));

  sl.registerLazySingleton<AuthServiceRepository>(() =>
      AuthServiceModelRepository(
          networkInfo: sl(), userServiceRemoteDataSource: sl()));
  sl.registerLazySingleton<AuthServiceRemoteDataSource>(
      () => AuthServiceRemoteDataSource(client: sl()));

  ///account module
  sl.registerFactory(() => AccountBloc(
      getUserServiceUseCase: sl(),
      updateUserServiceUseCase: sl(),
      changePasswordUseCase: sl(),
      getAllNotificationsUseCase: sl(),
      getAllUsersUseCase: sl(),
      updateProfileStatusUseCase: sl()));
  sl.registerLazySingleton(
      () => GetAllUsersUseCase(userServiceRepository: sl()));
  sl.registerLazySingleton(
      () => GetUserServiceUseCase(userServiceRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateUserServiceUseCase(userServiceRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateProfileStatusUseCase(userServiceRepository: sl()));
  sl.registerLazySingleton(
      () => ChangePasswordUseCase(userServiceRepository: sl()));
  sl.registerLazySingleton(
      () => GetAllNotificationsUseCase(settingsRepository: sl()));

  sl.registerLazySingleton<UserServiceRepository>(() =>
      UserServiceModelRepository(
          networkInfo: sl(), userServiceRemoteDataSource: sl()));
  sl.registerLazySingleton<UserServiceRemoteDataSource>(
      () => UserServiceRemoteDataSource(client: sl()));

  /// order module
  sl.registerFactory(() => BookingBloc(
      getAllOrderUseCase: sl(),
      addOrderUseCase: sl(),
      updateOrderUseCase: sl(),
      sendRequestUseCase: sl()));
  sl.registerLazySingleton(() => GetAllOrderUseCase(orderRepository: sl()));
  sl.registerLazySingleton(() => AddOrderUseCase(orderRepository: sl()));
  sl.registerLazySingleton(() => CancelOrderUseCase(orderRepository: sl()));
  sl.registerLazySingleton(() => UpdateOrderUseCase(orderRepository: sl()));
  sl.registerLazySingleton<OrderRepository>(() =>
      OrderModelRepository(networkInfo: sl(), orderRemoteDataSource: sl()));
  sl.registerLazySingleton<OrderRemoteDataSourceImpl>(
      () => OrderRemoteDataSource(client: sl()));

  // request form
  sl.registerLazySingleton(() => SendRequestUseCase(orderRepository: sl()));

  sl.registerFactory(() => ChatBloc());

  //
  // /// settings module
  sl.registerLazySingleton<SettingsRepository>(() => SettingsModelRepository(
      networkInfo: sl(), settingsRemoteDataSourceImpl: sl()));
  sl.registerLazySingleton<SettingsRemoteDataSourceImpl>(
      () => SettingsRemoteDataSource(client: sl()));

  /// locations module
  sl.registerFactory(() => LocationsBloc(
        fetchUserLocationsUseCase: sl(),
        addLocationUseCase: sl(),
        removeLocationUseCase: sl(),
        updateLocationUseCase: sl(),
      ));
  sl.registerLazySingleton(
      () => FetchUserLocationsUseCase(locationsRepository: sl()));
  sl.registerLazySingleton(() => AddLocationUseCase(locationsRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateLocationUseCase(locationsRepository: sl()));
  sl.registerLazySingleton(
      () => RemoveLocationUseCase(locationsRepository: sl()));

  sl.registerLazySingleton<LocationsRepository>(() => LocationsModelRepository(
      networkInfo: sl(), locationRemoteDataSource: sl()));
  sl.registerLazySingleton<LocationRemoteDataSourceImpl>(
      () => LocationRemoteDataSource(client: sl()));

  /// categories bloc and classes initial
  sl.registerFactory(() => CategoriesBloc(
      getAllCategoryUseCase: sl(),
      getAllSlidersUseCase: sl(),
      getAllAllergiesUseCase: sl(),
      getAllPublicationsUseCase: sl()));
  sl.registerLazySingleton(
      () => GetAllCategoryUseCase(categoryRepository: sl()));
  sl.registerLazySingleton(
      () => GetAllAllergiesUseCase(categoryRepository: sl()));
  sl.registerLazySingleton(
      () => GetAllSlidersUseCase(categoryRepository: sl()));
  sl.registerLazySingleton(
      () => GetAllPublicationsUseCase(categoryRepository: sl()));
  sl.registerLazySingleton<CategoryRepository>(() => CategoryModelRepository(
      networkInfo: sl(), categoryRemoteDataSource: sl()));
  sl.registerLazySingleton<CategoryRemoteDataSourceImpl>(
      () => CategoryRemoteDataSource(client: sl()));

  /// nurses bloc and classes initial
  sl.registerFactory(
      () => NurseBloc(getAllNursesUseCase: sl(), rateNurseUseCase: sl()));
  sl.registerLazySingleton(() => GetAllNursesUseCase(nurseRepository: sl()));
  sl.registerLazySingleton(() => RateNurseUseCase(nurseRepository: sl()));
  sl.registerLazySingleton<NursesRepository>(() => NursesModelRepository(
      networkInfo: sl(), nursesRemoteDataSourceImpl: sl()));
  sl.registerLazySingleton<NursesRemoteDataSourceImpl>(
      () => NursesRemoteDataSource(client: sl()));

  /// doctors bloc and classes initial
  sl.registerFactory(
      () => DoctorBloc(getAllDoctorsUseCase: sl(), rateDoctorUseCase: sl()));
  sl.registerLazySingleton(() => GetAllDoctorsUseCase(doctorRepository: sl()));
  sl.registerLazySingleton(() => RateDoctorUseCase(doctorRepository: sl()));
  sl.registerLazySingleton<DoctorsRepository>(() => DoctorsModelRepository(
      networkInfo: sl(), doctorsRemoteDataSourceImpl: sl()));
  sl.registerLazySingleton<DoctorsRemoteDataSourceImpl>(
      () => DoctorsRemoteDataSource(client: sl()));

  /// search bloc and classes initial
  sl.registerFactory(() => SearchBloc(searchByServiceUseCase: sl()));
  sl.registerLazySingleton(
      () => SearchByServiceUseCase(searchRepository: sl()));
  sl.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(client: sl()));

  /// additional classes initial
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton(() => http.Client());
}
