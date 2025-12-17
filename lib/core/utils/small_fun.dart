import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:icare/core/strings/api/api_url.dart';
import 'package:icare/core/strings/enum/user_enum.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/features/authentication/presentation/screens/nurse/create_nurse_account.dart';
import 'package:icare/features/authentication/presentation/screens/login.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_bloc.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_event.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/root_app/bloc/root_event.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:icare/core/strings/constant.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/root_app/screens/root_screen.dart';
import 'package:icare/features/chat/presentation/screens/main_conversation.dart';
import 'package:url_launcher/url_launcher.dart';

class Util {
  // implemented this function after register and login
  static getAllUserAppData(
      {required BuildContext context, bool isSplash = false}) async {
    if (isSplash) {
      /// get all app data like [GOVERNORATE,CITIES]
      RootBloc.get(context).add(const FetchSettingEvent());
      NurseBloc.get(context).add(const FetchAllNurseEvent());
      NurseBloc.get(context).add(const FetchAllNurseEvent(page: 2));
    }
    CategoriesBloc.get(context).add(const FetchAllPublicationsEvent());
    CategoriesBloc.get(context).add(const FetchAllAllergiesEvent());
    BookingBloc.get(context).add(const FetchAllOrderEvent());
    AccountBloc.get(context)
      ..add(const FetchProfileDataEvent())
      ..add(const FetchAllNotificationsEvent())
      ..getAllServiceList();
    await updateLocationAndToken(context);
  }

  static updateLocationAndToken(context) async {
    try {
      bool locationEnabled = await Permission.location.serviceStatus.isEnabled;
      Position? position;
      if (locationEnabled)
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      var user = {
        'profile': '',
        'remember_token': await Util.setToken(),
        if (locationEnabled && position != null)
          'latitude': position.latitude.toString(),
        if (locationEnabled && position != null)
          'longitude': position.longitude.toString(),
      };
      AccountBloc.get(context).add(UpdateProfileEvent(user: user));
    } catch (e) {
      debugPrint("updateLocationAndTokenUtil: $e");
    }
  }

  static goToStore() async {
    if (Platform.isIOS) {
      return await openUrl("", externalApp: true);
    } else {
      return await openUrl(
          "https://play.google.com/store/apps/details?id=com.icare.icare_app",
          externalApp: true);
    }
  }

  static String getGreeting() {
    var time = DateTime.now().hour;
    if (time < 12) {
      return translate("icare.good_morning");
    } else {
      return translate("icare.good_evening");
    }
  }

  static String? validatePhone(String value) {
    String pattern = r'^(^\+9665[5|0|3|6|4|9|1|8|7]{1}[0-9]{7})$';
    String patternEg = r'^(^\+2[0]1[0-2|5]{1}[0-9]{8})$';
    RegExp regExp = RegExp(pattern);
    if (!(regExp.hasMatch(value) || (RegExp(patternEg).hasMatch(value)))) {
      return translate("login.phone_is_wrong");
    }
    return null;
  }

  static bool validatePhoneInput(String phone, BuildContext context) {
    if (phone.isNotEmpty) {
      String? txt = Util.validatePhone(phone);
      if (txt != null) {
        SnackBarBuilder.showFeedBackMessage(context, txt, DMUtil.getRED());
        return false;
      }
    }
    return true;
  }

  static Future<bool> verifyCode(String otp) async {
    try {
      // var vC = SharedPref().getPreferenceString(Constants.lastVerificationCode);
      // debugPrint("$vC $otp");
      return "8084".trim() == otp.trim();
    } catch (e) {
      debugPrint("verifyFirebaseCode: $e");
      return false;
    }
  }

  static Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  static openUrl(String url, {bool externalApp = false}) async {
    try {
      await canLaunchUrl(
                Uri.parse(url),
              ) ==
              true
          ? await launchUrl(Uri.parse(url),
              mode: externalApp
                  ? LaunchMode.externalApplication
                  : LaunchMode.platformDefault)
          : debugPrint("error when openGmsUrl");
    } catch (e) {
      debugPrint("openUrl: $e");
    }
  }

  static String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  static sendMailMsg({required String subject, required String msg}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'admin@icarestarsmed.com',
      query: encodeQueryParameters(<String, String>{
        subject: msg,
      }),
    );
    await canLaunchUrl(emailLaunchUri) == true
        ? await launchUrl(emailLaunchUri)
        : debugPrint("error when sendMailMsg");
  }

  static call(String phone) async {
    try {
      if (!phone.startsWith("0")) phone = "0$phone";
      phone = "tel:$phone";
      await canLaunchUrl(Uri.parse(phone)) == true
          ? await launchUrl(Uri.parse(phone))
          : debugPrint("error when call");
    } catch (e) {
      debugPrint("error when call: $e ");
    }
  }

  static sendSms(String phone) async {
    try {
      await LocationUtil.checkLocationPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var latLng = LatLng(position.latitude, position.longitude);
      Placemark address = await LocationUtil.getAndSaveLocationDetails(latLng);
      if (!phone.startsWith("0")) phone = "20$phone";
      var msg = "استغاثة "
          "\n"
          "${Util.getAddress()} - ${address.country}-${address.subLocality}-${address.street}-${address.administrativeArea}";
      final Uri smsLaunchUri = Uri(
        scheme: 'sms',
        path: phone,
        queryParameters: <String, String>{
          'body': Uri.encodeComponent(msg.toString().replaceAll("null", "")),
        },
      );
      await canLaunchUrl(smsLaunchUri) == true
          ? await launchUrl(smsLaunchUri)
          : debugPrint("error when sms");
    } catch (e) {
      debugPrint("error when call: $e ");
    }
  }

  static openMapApp(String lat, String long) async {
    var url =
        "https://www.google.com/maps/dir/?api=1&destination=$lat,$long&travelmode=driving";
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("sendWhatsApp: $e");
    }
  }

  static sendWhatsApp(
    String phone,
  ) async {
    var whatsappUrl =
        "whatsapp://send?phone=$phone&text=${Uri.encodeComponent("")}";
    try {
      await launchUrl(Uri.parse(whatsappUrl));
    } catch (e) {
      debugPrint("sendWhatsApp: $e");
    }
  }

  static calcDiscountRate(
      {required double oldPrice, required double newPrice}) {
    return ((oldPrice - newPrice) / oldPrice * 100).toStringAsFixed(2);
  }

  static bool checkUser() {
    return SharedPref.preferences.containPreference(Constants.userId);
  }

  static void changeLang(
      {required BuildContext ctx,
      bool isLogin = false,
      bool isRegisterNurse = false,
      String? lang}) {
    String lng = lang ?? (getLang() == "ar" ? "en_US" : "ar");
    changeLocale(ctx, lng);
    SharedPref.preferences.setPreferencesString(Constants.userLang, lng);
    // Fonts.update();
    // ApiUrl.updateSettingUrl();
    // RootBloc.get(ctx).add(const FetchSettingEvent());
    if (isLogin) {
      Util.pushPageAndRemoveRoutes(const LoginScreen(), ctx);
    } else if (isLogin) {
      Util.pushPageAndRemoveRoutes(const CreateNurseAccountScreen(), ctx);
    } else {
      Util.pushPageAndRemoveRoutes(const RootScreen(), ctx);
    }
  }

  static saveLocalData(Map<String, dynamic> bodyData) async {
    try {
      await SharedPref().setPreferencesString(
          Constants.userId, bodyData['user']['id'].toString());
      await SharedPref().setPreferencesString(
          Constants.userType, bodyData['user']['user_type'].toString());

      debugPrint("🔍 LOGIN RESPONSE BODY: $bodyData");
      // Save API authentication token (not FCM token)
      if (bodyData['token'] != null) {
        await SharedPref().setPreferencesString(
            Constants.apiToken, bodyData['token'].toString());
        debugPrint(
            "✅ API Token saved: ${bodyData['token'].toString().substring(0, 20)}...");
      } else if (bodyData['access_token'] != null) {
        await SharedPref().setPreferencesString(
            Constants.apiToken, bodyData['access_token'].toString());
        debugPrint(
            "✅ API Token saved: ${bodyData['access_token'].toString().substring(0, 20)}...");
      } else {
        debugPrint(
            "⚠️ No API token found in response. Full Data keys: ${bodyData.keys.toList()}");
      }

      // Note: No need to manually set ApiUrl.headerAuth anymore
      // It's now a getter that will automatically include the token
    } catch (e) {
      debugPrint("saveLocalData: $e");
    }
  }

  static bool isCustomer() {
    return getUserType().toString().trim().toLowerCase() ==
        UserEnum.CUSTOMER.name.toString().toLowerCase();
  }

  static bool isNurse() {
    return getUserType().toString().trim().toLowerCase() ==
        UserEnum.NURSE.name.toString().toLowerCase();
  }

  static bool isAssistant() {
    return getUserType().toString().trim().toLowerCase() ==
        UserEnum.ASSISTANT.name.toString().toLowerCase();
  }

  static String getUserType() {
    return SharedPref()
        .getPreferenceString(Constants.userType)
        .toString()
        .toLowerCase();
  }

  static Future<String> setToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    SharedPref().setPreferencesString(token.toString(), Constants.token);
    return token.toString();
  }

  /// Get FCM token for push notifications
  static String getFcmToken() {
    return SharedPref()
        .getPreferenceString(Constants.token)
        .toString()
        .trim()
        .replaceAll("null", "");
  }

  /// Get API authentication token from backend
  static String getToken() {
    return SharedPref()
        .getPreferenceString(Constants.apiToken)
        .toString()
        .trim()
        .replaceAll("null", "");
  }

  /// Alias for getToken() - Get API authentication token
  static String getApiToken() {
    return getToken();
  }

  static String getUserID() {
    return SharedPref().getPreferenceString(Constants.userId);
  }

  static String getCity() {
    return SharedPref()
        .getPreferenceString(Constants.city)
        .toString()
        .trim()
        .replaceAll("null", "");
  }

  static String getAddress() {
    return SharedPref()
        .getPreferenceString(Constants.address)
        .toString()
        .trim()
        .replaceAll("null", "");
  }

  static String getName() {
    return SharedPref()
        .getPreferenceString(Constants.name)
        .toString()
        .trim()
        .replaceAll("null", "");
  }

  static String getEmail() {
    return SharedPref()
        .getPreferenceString(Constants.email)
        .toString()
        .trim()
        .replaceAll("null", "");
  }

  static String getMobile() {
    return SharedPref()
        .getPreferenceString(Constants.mobile)
        .toString()
        .trim()
        .replaceAll("null", "");
  }

  static String getLang() {
    return SharedPref().getPreferenceString(Constants.userLang);
  }

  static double getLatitude() {
    return SharedPref().getPreferenceDouble(Constants.userLatitude);
  }

  static double getLongitude() {
    try {
      return SharedPref().getPreferenceDouble(Constants.userLongitude);
    } catch (e) {
      debugPrint("getLongitude: $e");
      return 0.0;
    }
  }

  static double getLocationDetails() {
    return SharedPref().getPreferenceDouble(Constants.userLocationDetails);
  }

  static pushPage(Widget route, BuildContext cxt) {
    return Navigator.push(
      cxt,
      MaterialPageRoute(builder: (context) => route),
    );
  }

  static pushPageAndRemoveRoutes(Widget pushRoute, BuildContext cxt) {
    Navigator.of(cxt).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext ctx) => pushRoute),
        (route) => false);
  }

  /// date time helper functions
  static bool isToday(DateTime dateTime) {
    if (DateTime.now().year == dateTime.year &&
        DateTime.now().month == dateTime.month &&
        DateTime.now().day == dateTime.day) {
      return true;
    }
    return false;
  }

  // return date in this format ->  2 November 2021
  static String formatToDayFullMonthYear(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date.toLocal());
  }

  // return time in this format ->  5:30 PM
  static String formatTimeToHMPMorAM(DateTime date) {
    return DateFormat('h:mm a').format(date.toLocal());
  }

  // return date in this format ->  2 - November
  static String formatToDayMonth(DateTime date) {
    if (isToday(date)) return "Today";
    return DateFormat('d - MMMM').format(date.toLocal());
  }

  static String calcBetweenTwoDateTime(DateTime date, DateTime anotherDate) {
    Duration diff = anotherDate.difference(date);
    if (diff.inMinutes.toDouble() > 10 && diff.inHours.toDouble() < 12) {
      return "${diff.inHours} ${translate("order.hours")} - ${diff.inDays} ${translate("order.day")}";
    }
    if (diff.inHours.toDouble() > 12) {
      return "${diff.inDays} ${translate("order.day")}";
    }
    return "${diff.inMinutes} ${translate("order.minute")} - ${diff.inHours} ${translate("order.hours")} - ${diff.inDays} ${translate("order.day")}";
  }

  static Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceId;

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }
    } on PlatformException {
      debugPrint('Failed to get device ID');
    }

    return deviceId;
  }

  /// Open chat conversation screen
  static void openChat({
    required BuildContext context,
    required String receiverID,
    required String receiverName,
    required String chatRoomID,
  }) {
    // Import needed: 'package:icare/features/chat/presentation/screens/main_conversation.dart'
    final conversationScreen = ConversationScreen(
      receiverID: receiverID,
      receiverName: receiverName,
      chatRoomID: chatRoomID,
    );
    pushPage(conversationScreen, context);
  }

  /// Make a phone call with validation
  static Future<void> makeCall({
    required BuildContext context,
    required String? phoneNumber,
  }) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      SnackBarBuilder.showFeedBackMessage(
        context,
        translate("toast.no_phone_number"),
        Colors.red,
      );
      return;
    }

    try {
      await call(phoneNumber);
    } catch (e) {
      debugPrint("makeCall error: $e");
      SnackBarBuilder.showFeedBackMessage(
        context,
        translate("toast.oops"),
        Colors.red,
      );
    }
  }
}
