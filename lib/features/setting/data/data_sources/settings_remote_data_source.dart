import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/strings/api/api_url.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/setting/data/models/about_us_model.dart';
import 'package:icare/features/setting/data/models/city_model.dart';
import 'package:icare/features/setting/data/models/notifications_model.dart';
import 'package:icare/features/setting/data/models/privacy_model.dart';
import 'package:icare/features/setting/data/models/refund_policy_model.dart';
import 'package:icare/features/setting/data/models/terms_model.dart';
import 'package:icare/features/setting/data/models/specialty_model.dart';
import 'package:icare/features/categories/data/models/allergies.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/core/constants/constant.dart';

abstract class SettingsRemoteDataSourceImpl {
  Future<List<AboutUsModel>> getAboutUsData();
  Future<List<RefundPolicyModel>> getRefundPolicyData();
  Future<List<TermsModel>> getTermsData();
  Future<List<PrivacyModel>> getPrivacyData();

  /// user settings
  Future<List<NotificationsModel>> getAllNotifications();
}

class SettingsRemoteDataSource extends SettingsRemoteDataSourceImpl {
  final http.Client client;
  SettingsRemoteDataSource({required this.client});

  @override
  Future<List<NotificationsModel>> getAllNotifications() async {
    var response = await client.get(
        Uri.parse("${ApiUrl.USER_NOTIFICATIONS}/${Util.getUserID()}"),
        headers: ApiUrl.headerAuth);
    // debugPrint("getAllNotifications ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      if (data == null) {
        return [];
      }
      return NotificationsModel.notificationListFromJson(jsonEncode(data));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<AboutUsModel>> getAboutUsData() {
    throw UnimplementedError();
  }

  @override
  Future<List<PrivacyModel>> getPrivacyData() {
    throw UnimplementedError();
  }

  @override
  Future<List<RefundPolicyModel>> getRefundPolicyData() {
    throw UnimplementedError();
  }

  @override
  Future<List<TermsModel>> getTermsData() {
    throw UnimplementedError();
  }

  static Future<bool> sendContactUs(Map<String, dynamic> data) async {
    var response = await http.post(Uri.parse(ApiUrl.BASE_URL), body: data);
    // debugPrint("sendContactUs: ${response.body}");
    var decodedData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (decodedData['success'] == true) {
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  static Future<List<CityModel>> fetchAllGovernorates() async {
    // 1. Check local cache
    try {
      String cachedData =
          SharedPref().getPreferenceString(Constants.governoratesCache);
      if (cachedData.isNotEmpty) {
        // Refresh in background silently
        Future.microtask(() async {
          try {
            var response = await http.get(Uri.parse(ApiUrl.GOVERNORATES));
            if (response.statusCode == 200) {
              var decodedData = jsonDecode(response.body);
              if (decodedData['status']) {
                SharedPref().setPreferencesString(Constants.governoratesCache,
                    jsonEncode(decodedData['data']));
              }
            }
          } catch (e) {
            // Silent refresh failed for governorates
          }
        });
        return CityModel.listFromJson(cachedData);
      }
    } catch (e) {
      // Cache read error for governorates
    }

    // 2. Fetch from API if cache is empty
    try {
      var response = await http.get(Uri.parse(ApiUrl.GOVERNORATES));
      // fetchAllGovernorates

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        if (decodedData['status']) {
          String jsonList = jsonEncode(decodedData['data']);
          SharedPref()
              .setPreferencesString(Constants.governoratesCache, jsonList);
          return CityModel.listFromJson(jsonList);
        }
      }
    } catch (e) {
      // API error for governorates
    }
    return [];
  }

  static Future<List<CityModel>> fetchAllCities() async {
    // 1. Check local cache
    try {
      String cachedData =
          SharedPref().getPreferenceString(Constants.citiesCache);
      if (cachedData.isNotEmpty) {
        // Refresh in background silently
        Future.microtask(() async {
          try {
            var response = await http.get(Uri.parse(ApiUrl.CITIES));
            if (response.statusCode == 200) {
              var decodedData = jsonDecode(response.body);
              if (decodedData['status']) {
                SharedPref().setPreferencesString(
                    Constants.citiesCache, jsonEncode(decodedData['data']));
              }
            }
          } catch (e) {
            // Silent refresh failed for cities
          }
        });
        return CityModel.listFromJson(cachedData);
      }
    } catch (e) {
      // Cache read error for cities
    }

    // 2. Fetch from API if cache is empty
    try {
      var response = await http.get(Uri.parse(ApiUrl.CITIES));
      // fetchAllCities

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        if (decodedData['status']) {
          String jsonList = jsonEncode(decodedData['data']);
          SharedPref().setPreferencesString(Constants.citiesCache, jsonList);
          return CityModel.listFromJson(jsonList);
        }
      }
    } catch (e) {
      // API error for cities
    }
    return [];
  }

  static Future<List<SpecialtyModel>> fetchAllSpecialties() async {
    var response = await http.get(
      Uri.parse(ApiUrl.SPECIALTIES),
      headers: ApiUrl.headerAuth,
    );
    // fetchAllSpecialties

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      if (decodedData['status']) {
        return SpecialtyModel.listFromJson(jsonEncode(decodedData['data']));
      }
      return [];
    } else {
      return [];
    }
  }

  static Future<List<AllergiesModel>> fetchAllAllergies() async {
    // 1. Check local cache
    try {
      String cachedData =
          SharedPref().getPreferenceString(Constants.allergiesCache);
      if (cachedData.isNotEmpty) {
        // Refresh in background silently
        Future.microtask(() async {
          try {
            var response = await http.get(
              Uri.parse(ApiUrl.ALLERGIES),
              headers: ApiUrl.headerAuth,
            );
            if (response.statusCode == 200) {
              var decodedData = jsonDecode(response.body);
              if (decodedData['status']) {
                SharedPref().setPreferencesString(
                    Constants.allergiesCache, jsonEncode(decodedData['data']));
              }
            }
          } catch (e) {
            // Silent refresh failed for allergies
          }
        });
        return AllergiesModel.listModelFromJson(cachedData);
      }
    } catch (e) {
      // Cache read error for allergies
    }

    // 2. Fetch from API if cache is empty
    try {
      var response = await http.get(
        Uri.parse(ApiUrl.ALLERGIES),
        headers: ApiUrl.headerAuth,
      );
      // fetchAllAllergies

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        if (decodedData['status']) {
          String jsonList = jsonEncode(decodedData['data']);
          SharedPref().setPreferencesString(Constants.allergiesCache, jsonList);
          return AllergiesModel.listModelFromJson(jsonList);
        }
      }
    } catch (e) {
      // API error for allergies
    }
    return [];
  }
}
