// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:icare/core/utils/notifications_utils.dart';
import 'package:icare/core/utils/small_fun.dart';

class ApiUrl {
  static Map<String, String> headerAuth = {
    'Content-Type': 'application/json',
    if (Util.checkUser()) 'ID': Util.getUserID(),
    'lat': Util.getLatitude().toString(),
    'long': Util.getLongitude().toString(),
    // if(Util.checkUser())'Authorization': 'Bearer ${Util.getToken()}',
  };

  static Future<Map<String, String>> secureData() async {
    return {
      'device_token': await NotificationsUtils.getFcmToken() ?? '',
      'device_id': await Util.getDeviceId() ?? '',
    };
  }

  // static const String BASE_URL = 'http://10.0.2.2:8000/api/';

  //new subdomain
  static const String MAIN_DOMAIN = 'https://admin.i-care.one';

  static const String BASE_URL = '$MAIN_DOMAIN/api/v1/';
  static const String STORAGE_URL = '$MAIN_DOMAIN/public/';

  //auth
  static const String REGISTER_URL = '${BASE_URL}auth/signup';
  static const String LOGIN_URL = '${BASE_URL}auth/login';
  static const String SOCIAL_AUTH_URL = '${BASE_URL}auth/social';
  static const String SEND_OTP = '${BASE_URL}send-otp';

  //user data
  static const String USER_PROFILE_DATA = '${BASE_URL}user/info';
  static const String UPDATE_USER_PROFILE = '${BASE_URL}user/update';
  static const String UPDATE_USER_PROFILE_STATUS =
      '${BASE_URL}user/update/status';
  static const String UPDATE_USER_PROFILE_IMG = '${BASE_URL}user/update/img/';
  static const String SEND_NOTIFICATION = '${BASE_URL}send-notification';

  static const String PATIENT_ACCESS = '${BASE_URL}patient_access';
  static const String GIVE_ACCESS = '${BASE_URL}give_access';

  static const String UPDATE_USER_PASSWORD_PROFILE =
      '${BASE_URL}auth/password/reset';
  static const String USER_NOTIFICATIONS = '${BASE_URL}notifications';
  static const String FETCH_ALL_USER_PROFILE = '${BASE_URL}users';

  static const String UPDATE_USER_TOKEN = '${BASE_URL}update_token';

  /// update token with wordpress plugin api

  static const String UPDATE_NURSE_DATA = '${BASE_URL}nurse/options';

  //address
  static const String FETCH_ADDRESS = '${BASE_URL}user/addresses';
  static const String ADD_NEW_ADDRESS = '${BASE_URL}user/address';
  static const String UPDATE_ADDRESS =
      '${BASE_URL}user/address'; //user/address/{{addressID}}
  static const String REMOVE_ADDRESS =
      '${BASE_URL}user/address/'; //user/address/{{addressID}}

  static const String nurses = '${BASE_URL}nurses';
  static const String RATE_NURSE = '${BASE_URL}nurse/rate';
  static const String COMMENTS_URL = '${BASE_URL}reviews';
  static const String OFFERS_URL = '${BASE_URL}products/featured';
  static const String SLIDERS_URL = '${BASE_URL}sliders/all';
  static const String CATEGORIES_URL = '${BASE_URL}categories/all';
  static const String ALLERGIES = '${BASE_URL}allergies';
  static const String SERVICES = '${BASE_URL}service/list';

  //order
  static const String ADD_ORDER = '${BASE_URL}orders/store';
  static const String FETCH_ALL_ORDERS = '${BASE_URL}orders';
  static const String UPDATE_ORDER_STATUS = '${BASE_URL}orders/update/status';
  static const String CANCEL_ORDER = '${BASE_URL}orders';
  static const String coupon = '${BASE_URL}coupon';

  //request
  static const String SEND_REQUEST = '${BASE_URL}request/send';
  static const String ACCEPT_OFFER = '${BASE_URL}request/offer/accept';

  //publications
  static const String PUBLICATIONS =
      '${BASE_URL}publications'; //publications/{type}

  //settings
  static const String GOVERNORATES = '${BASE_URL}governorates';
  static const String CITIES = '${BASE_URL}cities';
}
