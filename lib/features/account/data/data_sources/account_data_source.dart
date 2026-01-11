import 'dart:convert';
import 'package:icare/features/authentication/data/models/auth_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/strings/api/api_url.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/data/models/user_service_model.dart';
import 'package:icare/features/categories/data/models/services.dart';

abstract class UserServiceRemoteDataSourceImpl {
  Future<UserServiceModel> getUserData();
  Future<UserServiceModel> updateUserProfile(
      {required Map<String, dynamic> userData});
  Future<bool> updateProfileStatus({required Map<String, dynamic> userData});
  Future<AuthResponse> changePassword({required Map<String, dynamic> data});
  Future<List<UserServiceModel>> getAllUsers();
  Future<UserServiceModel> fetchUserFullData({required String userId});
}

class UserServiceRemoteDataSource implements UserServiceRemoteDataSourceImpl {
  final http.Client client;
  UserServiceRemoteDataSource({required this.client});

  @override
  Future<UserServiceModel> getUserData() async {
    var response = await client.get(
        Uri.parse("${ApiUrl.USER_PROFILE_DATA}/${ApiUrl.headerAuth['ID']}"),
        headers: ApiUrl.headerAuth);
    debugPrint("getUserData: ${response.body}");
    var decodedData = json.decode(response.body);

    if (decodedData['success']) {
      var body = json.decode(response.body);
      var userData = body['data']['user'][0];

      // ✅ Debug logging للتشخيص
      debugPrint("🔍 user_type: ${userData['user_type']}");
      debugPrint("🔍 Has 'nurse' key: ${userData.containsKey('nurse')}");
      debugPrint("🔍 Has 'doctor' key: ${userData.containsKey('doctor')}");

      if (userData['user_type'] == 'doctor') {
        debugPrint("🔍 doctor object: ${userData['doctor']}");
        debugPrint("🔍 specialties_id in root: ${userData['specialties_id']}");
      }

      return UserServiceModel.fromJson(userData);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserServiceModel> updateUserProfile(
      {required Map<String, dynamic> userData}) async {
    var res = const UserServiceModel(
        userId: 0,
        userName: '',
        email: '',
        phoneNumber: "",
        userType: "",
        address: "",
        image: "");
    if (userData['allergies'] != null) {
      res = await updatePatientData(userData: userData);
    }
    if (userData['medical_conditions'] != null) {
      userData['value'] = userData['medical_conditions'];
      userData['type'] = 'medical_conditions';
      res = await updatePatientData(userData: userData);
    }
    if (userData['publications'] != null) {
      userData['value'] = userData['publications'];
      userData['type'] = 'publications';
      res = await updatePatientData(userData: userData);
    }

    if (userData['emergency_contacts'] != null) {
      userData['value'] = userData['emergency_contacts'];
      userData['type'] = 'emergency_contacts';
      res = await updatePatientData(userData: userData);
    }
    if (userData['avatar'] != null) {
      await updateImg(imgPath: userData['avatar']);
    }
    if (userData['profile'] != null) {
      var body = {
        if (userData['name'] != null) 'name': userData['name'] ?? '',
        if (userData['email'] != null) 'email': userData['email'],
        if (userData['phone'] != null) 'phone': userData['phone'],
        if (userData['address'] != null) 'address': userData['address'],
        if (userData['governorate'] != null)
          'governorate': userData['governorate'],
        if (userData['city'] != null) 'city': userData['city'],
        if (userData['postal_code'] != null)
          'postal_code': userData['postal_code'],
        if (userData['latitude'] != null) 'latitude': userData['latitude'],
        if (userData['longitude'] != null) 'longitude': userData['longitude'],
        if (userData['remember_token'] != null)
          'remember_token': userData['remember_token'],
        if (userData['heart_rate'] != null)
          'heart_rate': userData['heart_rate'],
        if (userData['blood_pressure'] != null)
          'blood_pressure': userData['blood_pressure'],
        if (userData['height'] != null) 'height': userData['height'],
        if (userData['weight'] != null) 'weight': userData['weight'],
        if (userData['pulse_rate'] != null)
          'pulse_rate': userData['pulse_rate'],
      };
      var response = await client.post(
          Uri.parse("${ApiUrl.UPDATE_USER_PROFILE}/${ApiUrl.headerAuth['ID']}"),
          body: json.encode(body),
          headers: ApiUrl.headerAuth);
      debugPrint("updateUserProfile: ${response.body}");
      var decodedData = jsonDecode(response.body);
      if (decodedData['status'] == true) {
        return UserServiceModel.fromJson(decodedData['user']);
      } else {
        return const UserServiceModel(
            userId: 0,
            userName: '',
            email: '',
            phoneNumber: "",
            userType: "",
            address: "",
            image: "");
      }
    }
    return res;
  }

  Future<UserServiceModel> updatePatientData(
      {required Map<String, dynamic> userData}) async {
    var data = {
      if (userData['allergies'] != null) 'allergies': userData['allergies'],
      if (userData['value'] != null) 'value': userData['value'],
      if (userData['type'] != null) 'type': userData['type'],
    };
    var response = await client.post(
        Uri.parse("${ApiUrl.UPDATE_USER_PROFILE}/${ApiUrl.headerAuth['ID']}"),
        body: json.encode(data),
        headers: ApiUrl.headerAuth);
    debugPrint("updatePatientData: ${response.body}");
    var decodedData = jsonDecode(response.body);
    if (decodedData['status'] == true) {
      return UserServiceModel.fromJson(decodedData['user']);
    } else {
      return const UserServiceModel(
          userId: 0,
          userName: '',
          email: '',
          phoneNumber: "",
          userType: "",
          address: "",
          image: "");
    }
  }

  @override
  Future<bool> updateProfileStatus(
      {required Map<String, dynamic> userData}) async {
    var response = await client.post(
        Uri.parse(
            "${ApiUrl.UPDATE_USER_PROFILE_STATUS}/${userData['status'] ?? 'offline'}/${Util.getUserID()}"),
        headers: ApiUrl.headerAuth);
    debugPrint("updateProfileStatus: ${response.body}");
    var decodedData = jsonDecode(response.body);
    return decodedData['status'] == true;
  }

  static Future<UserServiceModel> updateNurseOptionsValue(
      {required Map<String, dynamic> userData}) async {
    var data = {
      'user_id': Util.getUserID(),
      if (userData['languages'] != null) 'languages': userData['languages'],
      if (userData['education'] != null) 'education': userData['education'],
      if (userData['publications'] != null)
        'publications': userData['publications'],
      if (userData['courses'] != null) 'courses': userData['courses'],
      if (userData['emergency_contacts'] != null)
        'emergency_contacts': userData['emergency_contacts'],
      if (userData['services'] != null) 'services': userData['services'],
    };
    var response = await http.post(Uri.parse(ApiUrl.UPDATE_NURSE_DATA),
        body: json.encode(data), headers: ApiUrl.headerAuth);
    debugPrint("updateNurseOptionsValue: ${response.body}");
    var decodedData = jsonDecode(response.body);
    if (decodedData['status'] == true) {
      return const UserServiceModel(
          userId: 0,
          userName: '',
          email: '',
          phoneNumber: "",
          userType: "",
          address: "",
          image: "");
    } else {
      return const UserServiceModel(
          userId: 0,
          userName: '',
          email: '',
          phoneNumber: "",
          userType: "",
          address: "",
          image: "");
    }
  }

  static Future<UserServiceModel> updateDoctorOptionsValue(
      {required Map<String, dynamic> userData}) async {
    var data = {
      'user_id': Util.getUserID(),
      if (userData['languages'] != null) 'languages': userData['languages'],
      if (userData['education'] != null) 'education': userData['education'],
      if (userData['publications'] != null)
        'publications': userData['publications'],
      if (userData['courses'] != null) 'courses': userData['courses'],
      if (userData['emergency_contacts'] != null)
        'emergency_contacts': userData['emergency_contacts'],
      // ✅ FIX: Send single specialty ID (integer) instead of array
      if (userData['specialties_id'] != null)
        'specialties_id': userData['specialties_id'],
    };
    var response = await http.post(Uri.parse(ApiUrl.UPDATE_DOCTOR_DATA),
        body: json.encode(data), headers: ApiUrl.headerAuth);
    debugPrint("updateDoctorOptionsValue: ${response.body}");
    var decodedData = jsonDecode(response.body);
    if (decodedData['status'] == true) {
      return const UserServiceModel(
          userId: 0,
          userName: '',
          email: '',
          phoneNumber: "",
          userType: "",
          address: "",
          image: "");
    } else {
      return const UserServiceModel(
          userId: 0,
          userName: '',
          email: '',
          phoneNumber: "",
          userType: "",
          address: "",
          image: "");
    }
  }

  static Future<List<ServicesModel>> getAllServicesList(
      {String? userType}) async {
    try {
      // Use role-based endpoints
      String url;
      if (userType == 'nurse') {
        url = ApiUrl.NURSE_SERVICES;
        debugPrint("🔍 Fetching services for NURSE");
      } else if (userType == 'assistant') {
        url = ApiUrl.ASSISTANT_SERVICES;
        debugPrint("🔍 Fetching services for ASSISTANT");
      } else {
        url = ApiUrl.SERVICES;
        debugPrint("🔍 Fetching services (fallback endpoint)");
      }

      var response = await http.get(Uri.parse(url), headers: ApiUrl.headerAuth);

      debugPrint("📥 getAllServicesList Response: ${response.statusCode}");
      debugPrint("📥 URL: $url");

      var decodedData = jsonDecode(response.body);
      if (decodedData['status'] == true) {
        var services =
            ServicesModel.listModelFromJson(jsonEncode(decodedData['data']));
        debugPrint(
            "✅ Loaded ${services.length} services${userType != null ? " for $userType" : ""}");

        return services;
      } else {
        debugPrint("❌ API returned status: false");
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error in getAllServicesList: $e");
      return [];
    }
  }

  static Future<bool> updateImg({required String imgPath}) async {
    try {
      String url =
          "${ApiUrl.UPDATE_USER_PROFILE_IMG}${Util.getUserID()}/profile";
      var request = http.MultipartRequest('POST', Uri.parse(url));
      var headers = ApiUrl.headerAuth;
      var file = await http.MultipartFile.fromPath('avatar', imgPath);
      request.files.add(file);
      request.headers.addAll(headers);
      var streamedResponse = await request.send();
      var res = await http.Response.fromStream(streamedResponse);
      debugPrint("updateImg: ${res.body}");
      var decodedData = jsonDecode(res.body);
      if (decodedData['status'] == true) return true;
      return false;
    } catch (e) {
      debugPrint("updateImg $e");
      return false;
    }
  }

  @override
  Future<AuthResponse> changePassword(
      {required Map<String, dynamic> data}) async {
    var body = {
      'id': data['id'],
      'password': data['password'],
    };
    var response = await client
        .post(Uri.parse(ApiUrl.UPDATE_USER_PASSWORD_PROFILE), body: body);
    debugPrint("changePassword: ${response.body}");
    var decodedData = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodedData['status'] &&
          decodedData['message'].toString().contains("Successfully")) {
        return AuthResponse(
            msg: translate("toast.update_user_data"), isSuccess: true);
      }
      //translate("login.phone_not_registered"):translate("toast.oops")
      return AuthResponse(msg: translate("toast.oops"), isFailed: true);
    } else {
      return AuthResponse(msg: translate("toast.oops"), isFailed: true);
    }
  }

  @override
  Future<List<UserServiceModel>> getAllUsers() async {
    List<UserServiceModel> users = [];
    var response = await client.get(Uri.parse(ApiUrl.FETCH_ALL_USER_PROFILE),
        headers: ApiUrl.headerAuth);
    // debugPrint("getAllUsers: ${response.body}");
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      for (var i in body['data']) {
        users.add(UserServiceModel.fromJson(i));
      }
      return users;
    } else {
      throw ServerException();
    }
  }

  static Future<UserServiceModel> getUserFullData(String userID) async {
    var response = await http.get(
        Uri.parse("${ApiUrl.USER_PROFILE_DATA}/$userID"),
        headers: ApiUrl.headerAuth);
    debugPrint("getUserFullData: ${response.body}");
    var decodedData = json.decode(response.body);
    if (decodedData['success']) {
      var body = json.decode(response.body);
      var userDataList = body['data']['user'];
      if (userDataList is List && userDataList.isNotEmpty) {
        return UserServiceModel.fromJson(userDataList[0]);
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserServiceModel> fetchUserFullData({required String userId}) async {
    return getUserFullData(userId);
  }

  static Future<bool> sendNotification(
      {required Map<String, dynamic> data}) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(ApiUrl.SEND_NOTIFICATION));
      var headers = ApiUrl.headerAuth;
      request.headers.addAll(headers);
      request.fields['user_id'] = data['user_id'];
      request.fields['msg'] = data['msg'];
      var streamedResponse = await request.send();
      var res = await http.Response.fromStream(streamedResponse);
      debugPrint("sendNotification: ${res.body}");
      var decodedData = jsonDecode(res.body);
      if (decodedData['status'] == true) return true;
      return false;
    } catch (e) {
      debugPrint("sendNotification $e");
      return false;
    }
  }
}
