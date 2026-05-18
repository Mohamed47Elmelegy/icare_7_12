import 'package:icare/core/di/injection_core.dart';
import 'package:icare/features/booking/data/data_sources/order_remote_data_source.dart';
import 'package:icare/features/booking/data/repositories/order_model_repository.dart';
import 'package:icare/features/booking/domain/repositories/oder_repository.dart';
import 'package:icare/features/booking/domain/use_cases/add_order_usecase.dart';
import 'package:icare/features/booking/domain/use_cases/delete_order_usecase.dart';
import 'package:icare/features/booking/domain/use_cases/get_all_order_usecase.dart';
import 'package:icare/features/booking/domain/use_cases/get_ongoing_bookings_usecase.dart';
import 'package:icare/features/booking/domain/use_cases/get_patient_details_usecase.dart';
import 'package:icare/features/booking/domain/use_cases/send_request_usecase.dart';
import 'package:icare/features/booking/domain/use_cases/update_order_usecase.dart';
import 'package:icare/features/booking/presentation/bloc/booking_nurse/booking_nurse_cubit.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';

void initBookingDependencies() {
  // BLoC & Cubit
  sl.registerLazySingleton(() => BookingBloc(
      getAllOrderUseCase: sl(),
      getOngoingBookingsUseCase: sl(),
      addOrderUseCase: sl(),
      updateOrderUseCase: sl(),
      sendRequestUseCase: sl()));

  sl.registerLazySingleton(
      () => BookingNurseCubit(getPatientDetailsUseCase: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetAllOrderUseCase(orderRepository: sl()));
  sl.registerLazySingleton(
      () => GetOngoingBookingsUseCase(orderRepository: sl()));
  sl.registerLazySingleton(() => GetPatientDetailsUseCase(sl()));
  sl.registerLazySingleton(() => AddOrderUseCase(orderRepository: sl()));
  sl.registerLazySingleton(() => CancelOrderUseCase(orderRepository: sl()));
  sl.registerLazySingleton(() => UpdateOrderUseCase(orderRepository: sl()));
  sl.registerLazySingleton(() => SendRequestUseCase(orderRepository: sl()));

  // Repositories
  sl.registerLazySingleton<OrderRepository>(() => OrderModelRepository(
        networkInfo: sl(),
        orderRemoteDataSource: sl(),
      ));

  // DataSources
  sl.registerLazySingleton<OrderRemoteDataSourceImpl>(
      () => OrderRemoteDataSource(client: sl()));
}
