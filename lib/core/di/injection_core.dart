import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:icare/core/network/auth_interceptor.dart';
import 'package:icare/core/network/network.dart';
import 'package:icare/core/strings/api/api_url.dart';

// Single source of truth for GetIt instance
final sl = GetIt.instance;

Future<void> initCoreDependencies() async {
  // Network Information
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // HTTP Client (for legacy code)
  sl.registerLazySingleton(() => http.Client());

  // Dio setup (Production standard)
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiUrl.BASE_URL,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      error: true,
    ));

    return dio;
  });
}
