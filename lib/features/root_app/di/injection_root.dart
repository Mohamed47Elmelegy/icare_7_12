import 'package:icare/core/di/injection_core.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';

void initRootDependencies() {
  // BLoC
  sl.registerLazySingleton(() => RootBloc());
}
