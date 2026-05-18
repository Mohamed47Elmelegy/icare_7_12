import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;
import 'package:icare/core/constants/constant.dart';
import 'package:icare/core/strings/api/api_url.dart';
import 'package:icare/core/utils/notifications_utils.dart';
import 'package:icare/core/utils/set_notification.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';
import 'package:icare/features/authentication/data/models/user_service_model.dart';

import 'package:dio/dio.dart';
import 'package:icare/core/network/token_storage_helper.dart';

abstract class AuthServiceRemoteDataSourceImpl {
  Future<AuthResponse> registerUser(Map<String, dynamic> userData);
  Future<AuthResponse> loginUser(Map<String, dynamic> userData);
  Future<AuthResponse> socialAuthUser(Map<String, dynamic> userData);
}

class AuthServiceRemoteDataSource implements AuthServiceRemoteDataSourceImpl {
  final Dio dioClient;

  AuthServiceRemoteDataSource({required this.dioClient});

  @override
  Future<AuthResponse> loginUser(Map<String, dynamic> userData) async {
    // 🔴 Ensure a clean state for the new login attempt
    await SharedPref().clearPreferences();
    await TokenStorageHelper.deleteToken();

    try {
      var data = {
        if (userData['phone'] != null) 'phone': userData['phone'],
        if (userData['email'] != null) 'email': userData['email'],
        'password': userData['password'],
        'device_info': await ApiUrl.secureData(),
      };

      var response = await dioClient.post(
        ApiUrl.LOGIN_URL,
        data: data,
      );

      var decodedData = response.data;
      debugPrint("loginUser Response: $decodedData");

      if (decodedData['status'] == true ||
          decodedData['user'] != null ||
          decodedData['access_token'] != null) {
        final Map<String, dynamic> bodyData = decodedData;

        // 🟢 FIX: Securely extract and save token BEFORE branching user types
        String? token = bodyData['access_token'] ?? bodyData['token'];
        if (token == null) {
          token = response.headers.value('authorization') ??
              response.headers.value('Authorization');
          if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
          }
        }

        if (token != null && token.isNotEmpty) {
          await TokenStorageHelper.saveToken(token);
          // Legacy fallback for ApiUrl.headerAuth
          await SharedPref().setPreferencesString(Constants.apiToken, token);
          debugPrint("✅ Token specifically saved for user from login.");
        }

        UserServiceModel user = UserServiceModel.fromJson(bodyData['user']);

        String userType =
            bodyData['user']['user_type']?.toString().toLowerCase() ??
                'customer';

        if (userType == 'customer') {
          await Util.saveLocalData(bodyData);
          SetNotification.showNotification(
              title: "", msg: translate("toast.welcome"));
        } else {
          // For professionals, save user_type and user_id temporarily for verification check
          await SharedPref().setPreferencesString(
              Constants.userId, bodyData['user']['id'].toString());
          await SharedPref().setPreferencesString(Constants.userType, userType);
          debugPrint("⏳ Professional user login - data saved");
        }

        return AuthResponse(user: user, msg: translate("toast.signup"));
      } else {
        String msg = decodedData['message'] ?? translate("toast.oops");
        if (msg.contains("Unauthorized password")) {
          return AuthResponse(
              user: null, msg: translate("toast.pass_incorrect"));
        } else if (msg.contains("Unauthorized") ||
            msg.contains("user not found")) {
          return AuthResponse(user: null, msg: translate("toast.sign_wrong"));
        } else if (msg.contains("User is banned")) {
          return AuthResponse(user: null, msg: translate("toast.user_banned"));
        }
        return AuthResponse(user: null, msg: msg);
      }
    } on DioException catch (e) {
      String msg = e.response?.data?['message'] ?? e.message ?? e.toString();
      if (msg.contains("Unauthorized password")) {
        return AuthResponse(user: null, msg: translate("toast.pass_incorrect"));
      } else if (msg.contains("Unauthorized") ||
          msg.contains("user not found")) {
        return AuthResponse(user: null, msg: translate("toast.sign_wrong"));
      }
      return AuthResponse(user: null, msg: msg);
    } catch (e) {
      return AuthResponse(user: null, msg: e.toString());
    }
  }

  @override
  Future<AuthResponse> registerUser(
    Map<String, dynamic> userData, {
    bool social = false,
  }) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(ApiUrl.REGISTER_URL));

      debugPrint("📤 send register user data: $userData");

      // ✅ تأكد من user_type
      String userType = userData['user_type'] ?? 'customer';
      if (userType.isEmpty || userType == 'null') {
        userType = 'customer';
      }

      debugPrint("👤 Registering as user_type: $userType");

      // Add device info
      request.fields['device_info'] = jsonEncode(await ApiUrl.secureData());

      // ✅ Required fields
      request.fields['user_type'] = userType;
      if (userData['name'] != null) request.fields['name'] = userData['name'];
      if (userData['email'] != null) {
        request.fields['email'] = userData['email'];
      }
      if (userData['phone'] != null) {
        request.fields['phone'] = userData['phone'];
      }
      if (userData['password'] != null) {
        request.fields['password'] = userData['password'];
      }

      // ✅ Optional fields
      if (userData['city'] != null) request.fields['city'] = userData['city'];
      if (userData['governorate'] != null) {
        request.fields['governorate'] = userData['governorate'];
      }
      if (userData['address'] != null) {
        request.fields['address'] = userData['address'];
      }
      if (userData['latitude'] != null) {
        request.fields['latitude'] = userData['latitude'].toString();
      }
      if (userData['longitude'] != null) {
        request.fields['longitude'] = userData['longitude'].toString();
      }
      if (userData['country_code'] != null) {
        request.fields['country_code'] = userData['country_code'];
      }
      if (userData['status'] != null) {
        request.fields['status'] = userData['status'];
      }
      if (userData['is_male'] != null) {
        request.fields['is_male'] = userData['is_male'].toString();
      }
      if (userData['specialties_id'] != null) {
        request.fields['specialties_id'] =
            userData['specialties_id'].toString();
      }

      // Nurse/Doctor additional data
      if (userData['languages'] != null) {
        request.fields['languages'] = userData['languages'];
      }
      if (userData['education'] != null) {
        request.fields['education'] = userData['education'];
      }
      if (userData['publications'] != null) {
        request.fields['publications'] = userData['publications'];
      }
      if (userData['courses'] != null) {
        request.fields['courses'] = userData['courses'];
      }

      // ✅ Files (only if provided)
      if (userData['license'] != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'license_practice', userData['license'].path));
      }
      if (userData['certificate'] != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'graduation_certificate', userData['certificate'].path));
      }
      if (userData['nurseID'] != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'identification_card', userData['nurseID'].path));
      }
      if (userData['associationCard'] != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'association_card', userData['associationCard'].path));
      }
      if (userData['related_job_id'] != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'related_job_id', userData['related_job_id'].path));
      }
      if (userData['avatar'] != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'avatar', userData['avatar'].path));
      }

      request.headers.addAll(ApiUrl.headerAuth);

      var streamedResponse = await request.send();
      var res = await http.Response.fromStream(streamedResponse);

      debugPrint("✅ registerUser response: ${res.body}");

      var decodedData = jsonDecode(res.body);

      // ✅ Check 'status', 'success', or presence of 'user'/'access_token' (backend may omit status flag)
      bool isSuccess = (decodedData['status'] == true) ||
          (decodedData['success'] == true) ||
          (decodedData['user'] != null) ||
          (decodedData['access_token'] != null);

      if (isSuccess) {
        // ✅ Save token for all user types
        String? token = decodedData['access_token'] ?? decodedData['token'];
        if (token != null && token.isNotEmpty) {
          await TokenStorageHelper.saveToken(token);
          await SharedPref().setPreferencesString(Constants.apiToken, token);
          debugPrint("✅ Token saved after registration for $userType");
        }

        if (userType == 'customer') {
          await Util.saveLocalData(decodedData);
          SetNotification.showNotification(
              title: "", msg: translate("toast.welcome"));
        } else {
          // Nurse/Doctor - save user_id and user_type then show pending notification
          await SharedPref().setPreferencesString(
              Constants.userId, decodedData['user']['id'].toString());
          await SharedPref().setPreferencesString(Constants.userType, userType);
          SetNotification.showNotification(
              title: "", msg: translate("toast.signup"));
        }

        // ✅ Safe parse: registration response is minimal (no allergies/lat/lng/nurse sub-object)
        // Failure to parse must NOT cause RegisterFailedState for nurse/doctor
        UserServiceModel? parsedUser;
        try {
          parsedUser = UserServiceModel.fromJson(decodedData['user']);
        } catch (parseError) {
          debugPrint(
              "⚠️ Could not fully parse user after registration (expected for professionals): $parseError");
          parsedUser = null;
        }

        return AuthResponse(
            user: parsedUser, msg: translate("toast.signup"), isSuccess: true);
      } else if (res.body.contains("already") ||
          res.body.contains("duplicate")) {
        return AuthResponse(
            user: null, msg: translate("toast.user_exist"), isFailed: true);
      } else {
        // Return the actual error message from backend
        String errorMsg = decodedData['message'] ?? translate("toast.oops");
        return AuthResponse(user: null, msg: errorMsg, isFailed: true);
      }
    } catch (e) {
      debugPrint("❌ registerUser error: $e");
      return AuthResponse(
          user: null, msg: "${translate("toast.oops")}: $e", isFailed: true);
    }
  }

  @override
  Future<AuthResponse> socialAuthUser(Map<String, dynamic> userData) async {
    // 🔴 Ensure a clean state for the new login attempt
    await SharedPref().clearPreferences();
    await TokenStorageHelper.deleteToken();

    try {
      var data = {
        'user_login': userData['email'],
        'email': userData['email'],
        'name': userData['email']
            .toString()
            .split("@")
            .first
            .toString()
            .replaceAll("null", ""),
        'password': userData['password'],
        'device_token': await NotificationsUtils.getFcmToken()
      };

      var response = await dioClient.post(
        ApiUrl.SOCIAL_AUTH_URL,
        data: data,
      );

      var decodedData = response.data;
      debugPrint("socialAuthUser response: $decodedData");
      if (decodedData['status'] == true ||
          decodedData['user'] != null ||
          decodedData['access_token'] != null) {
        final Map<String, dynamic> bodyData = decodedData;

        // Securely extract and save token
        String? token = bodyData['access_token'] ?? bodyData['token'];
        if (token != null && token.isNotEmpty) {
          await TokenStorageHelper.saveToken(token);
          await SharedPref().setPreferencesString(Constants.apiToken, token);
        }

        UserServiceModel user = UserServiceModel.fromJson(bodyData['user']);
        await Util.saveLocalData(bodyData);
        SetNotification.showNotification(
            title: "", msg: translate("toast.welcome"));
        return AuthResponse(user: user, msg: translate("toast.signup"));
      } else {
        String msg = decodedData['message'] ?? translate("toast.oops");
        if (msg.toLowerCase().contains("unauthorized") ||
            msg.toLowerCase().contains("user not found")) {
          return AuthResponse(user: null, msg: translate("toast.sign_wrong"));
        }
        return AuthResponse(user: null, msg: msg);
      }
    } on DioException catch (e) {
      String msg = e.response?.data?['message'] ?? e.message ?? e.toString();
      if (msg.contains("Unauthorized password")) {
        return AuthResponse(user: null, msg: translate("toast.pass_incorrect"));
      } else if (msg.contains("Unauthorized") ||
          msg.contains("user not found")) {
        return AuthResponse(user: null, msg: translate("toast.sign_wrong"));
      }
      return AuthResponse(user: null, msg: msg);
    } catch (e) {
      return AuthResponse(user: null, msg: e.toString());
    }
  }
}
