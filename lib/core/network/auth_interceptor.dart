import 'package:dio/dio.dart';
import 'package:icare/core/network/token_storage_helper.dart';
import 'package:icare/core/utils/shared_pref.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // 1. Fetch token securely
    final token = await TokenStorageHelper.getToken();

    // 2. Attach Authorization header natively
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // 3. Attach required default headers
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    // Check if lang overrides exist
    String lang = SharedPref().getPreferenceString('userLang');
    if (lang.isNotEmpty) {
      options.headers['Accept-Language'] = lang;
    }

    // Proceed with the request
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if the backend bounced the request due to Authentication
    if (err.response?.statusCode == 401) {
      // 1. Delete expired / invalid token
      await TokenStorageHelper.deleteToken();

      // Trigger global logout logic here later if needed
      // locator<AuthBloc>().add(ForcedLogoutEvent());
    }

    // Proceed throwing the error so the UI can catch it
    return super.onError(err, handler);
  }
}
