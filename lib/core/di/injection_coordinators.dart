import 'package:icare/core/coordinator/app_startup_coordinator.dart';
import 'package:icare/core/coordinator/feature_preload_manager.dart';
import 'package:icare/core/di/injection_core.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/services_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_bloc.dart';
import 'package:icare/features/doctor/presentation/bloc/doctors_bloc.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';

void initCoordinators() {
  // AppStartupCoordinator
  sl.registerLazySingleton<AppStartupCoordinator>(
    () => AppStartupCoordinator(
      accountBloc: sl<AccountBloc>(),
      rootBloc: sl<RootBloc>(),
      servicesBloc: sl<ServicesBloc>(),
    ),
  );

  // FeaturePreloadManager
  sl.registerLazySingleton<FeaturePreloadManager>(
    () => FeaturePreloadManager(
      doctorBloc: sl<DoctorBloc>(),
      nurseBloc: sl<NurseBloc>(),
      bookingBloc: sl<BookingBloc>(),
      categoriesBloc: sl<CategoriesBloc>(),
      accountBloc: sl<AccountBloc>(),
      servicesBloc: sl<ServicesBloc>(),
    ),
  );
}
