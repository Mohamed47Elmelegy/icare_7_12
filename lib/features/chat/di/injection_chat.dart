import 'package:icare/core/di/injection_core.dart';
import 'package:icare/features/chat/presentation/bloc/chat_bloc.dart';

void initChatDependencies() {
  // BLoC
  sl.registerLazySingleton(() => ChatBloc());
}
