import 'dart:convert';
import 'package:flutter/material.dart';
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
    debugPrint("getAllNotifications ${response.body}");
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
    var response = await http.get(Uri.parse(ApiUrl.GOVERNORATES));
    debugPrint("fetchAllGovernorates: ${response.body}");
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      if (decodedData['status']) {
        return CityModel.listFromJson(jsonEncode(decodedData['data']));
      }
      return [];
    } else {
      return [];
    }
  }

  static Future<List<CityModel>> fetchAllCities() async {
    var response = await http.get(Uri.parse(ApiUrl.CITIES));
    debugPrint("fetchAllCities: ${response.body}");
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      if (decodedData['status']) {
        return CityModel.listFromJson(jsonEncode(decodedData['data']));
      }
      return [];
    } else {
      return [];
    }
  }

  static Future<List<SpecialtyModel>> fetchAllSpecialties() async {
    var response = await http.get(
      Uri.parse(ApiUrl.SPECIALTIES),
      headers: ApiUrl.headerAuth,
    );
    debugPrint("fetchAllSpecialties: ${response.body}");
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
    var response = await http.get(
      Uri.parse(ApiUrl.ALLERGIES),
      headers: ApiUrl.headerAuth,
    );
    debugPrint("fetchAllAllergies: ${response.body}");
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      if (decodedData['status']) {
        return AllergiesModel.listModelFromJson(
            jsonEncode(decodedData['data']));
      }
      return [];
    } else {
      return [];
    }
  }
}
