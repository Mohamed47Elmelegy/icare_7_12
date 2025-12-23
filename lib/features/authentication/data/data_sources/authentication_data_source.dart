import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;
import 'package:icare/core/strings/api/api_url.dart';
import 'package:icare/core/utils/notifications_utils.dart';
import 'package:icare/core/utils/set_notification.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';
import 'package:icare/features/authentication/data/models/user_service_model.dart';

abstract class AuthServiceRemoteDataSourceImpl {
  Future<AuthResponse> registerUser(Map<String, dynamic> userData);
  Future<AuthResponse> loginUser(Map<String, dynamic> userData);
  Future<AuthResponse> socialAuthUser(Map<String, dynamic> userData);
}

class AuthServiceRemoteDataSource implements AuthServiceRemoteDataSourceImpl {
  final http.Client client;
  AuthServiceRemoteDataSource({required this.client});

  @override
  Future<AuthResponse> loginUser(Map<String, dynamic> userData) async {
    try {
      var data = {
        if (userData['phone'] != null) 'phone': userData['phone'],
        if (userData['email'] != null) 'email': userData['email'],
        'password': userData['password'],
        'device_info': await ApiUrl.secureData(),
      };
      var response = await client.post(
        Uri.parse(ApiUrl.LOGIN_URL),
        body: json.encode(data),
        headers: {
          "Content-Type": "application/json",
        },
      );
      var decodedData = json.decode(response.body);
      debugPrint("loginUser Body: ${response.body}");
      debugPrint("loginUser Headers: ${response.headers}");

      if (response.body.contains("Unauthorized password")) {
        return AuthResponse(user: null, msg: translate("toast.pass_incorrect"));
      } else if (response.body.contains("Unauthorized") ||
          response.body.contains("user not found")) {
        return AuthResponse(user: null, msg: translate("toast.sign_wrong"));
      } else if (response.body.contains("User is banned")) {
        return AuthResponse(user: null, msg: translate("toast.user_banned"));
      } else if (decodedData['status']) {
        final Map<String, dynamic> bodyData = json.decode(response.body);

        // Attempt to find token in headers if not in body
        if (bodyData['token'] == null && bodyData['access_token'] == null) {
          String? headerToken = response.headers['authorization'] ??
              response.headers['Authorization'];
          if (headerToken != null) {
            if (headerToken.startsWith("Bearer ")) {
              headerToken = headerToken.substring(7);
            }
            bodyData['access_token'] = headerToken;
            debugPrint("🎉 Token found in Headers: $headerToken");
          }
        }

        UserServiceModel user = UserServiceModel.fromJson(bodyData['user']);
        await Util.saveLocalData(bodyData);
        SetNotification.showNotification(
            title: "", msg: translate("toast.welcome"));
        return AuthResponse(user: user, msg: translate("toast.signup"));
      } else {
        return AuthResponse(user: null, msg: translate("toast.oops"));
      }
    } catch (e) {
      return AuthResponse(user: null, msg: e.toString());
    }
  }

  @override
  // Future<AuthResponse> registerUser(
  //   Map<String, dynamic> userData, {
  //   bool social = false,
  // }) async {

  //   try {
  //     var request =
  //         http.MultipartRequest('POST', Uri.parse(ApiUrl.REGISTER_URL));

  //     debugPrint("send register user data: $userData");
  //     request.fields['device_info'] = jsonEncode(await ApiUrl.secureData());
  //     if (userData['user_type'] == null || userData['user_type'] == "") {
  //       userData['user_type'] = "customer";
  //     }
  //     var headers = ApiUrl.headerAuth;
  //     if (userData['name'] != null) request.fields['name'] = userData['name'];
  //     if (userData['email'] != null) {
  //       request.fields['email'] = userData['email'];
  //     }
  //     if (userData['phone'] != null) {
  //       request.fields['phone'] = userData['phone'];
  //     }
  //     request.fields['user_type'] = userData['user_type'] == null
  //         ? "customer"
  //         : userData['user_type']
  //             .toString()
  //             .trim()
  //             .replaceAll("null", "customer");
  //     if (userData['city'] != null) request.fields['city'] = userData['city'];
  //     if (userData['governorate'] != null) {
  //       request.fields['governorate'] = userData['governorate'];
  //     }
  //     if (userData['address'] != null) {
  //       request.fields['address'] = userData['address'];
  //     }
  //     if (userData['latitude'] != null) {
  //       request.fields['latitude'] = userData['latitude'].toString();
  //     }
  //     if (userData['longitude'] != null) {
  //       request.fields['longitude'] = userData['longitude'].toString();
  //     }
  //     if (userData['country_code'] != null) {
  //       request.fields['country_code'] = userData['country_code'];
  //     }
  //     if (userData['status'] != null) {
  //       request.fields['status'] = userData['status'];
  //     }
  //     if (userData['password'] != null) {
  //       request.fields['password'] = userData['password'];
  //     }
  //     if (userData['is_male'] != null) {
  //       request.fields['is_male'] = userData['is_male'];
  //     }
  //     if (userData['specialties_id'] != null) {
  //       request.fields['specialties_id'] =
  //           userData['specialties_id'].toString();
  //     }

  //     if (userData['languages'] != null) {
  //       request.fields['languages'] = userData['languages'];
  //     }
  //     if (userData['education'] != null) {
  //       request.fields['education'] = userData['education'];
  //     }
  //     if (userData['publications'] != null) {
  //       request.fields['publications'] = userData['publications'];
  //     }
  //     if (userData['courses'] != null) {
  //       request.fields['courses'] = userData['courses'];
  //     }

  //     if (userData['license'] != null) {
  //       var file = await http.MultipartFile.fromPath(
  //           'license_practice', userData['license'].path);
  //       request.files.add(file);
  //     }
  //     if (userData['certificate'] != null) {
  //       var file = await http.MultipartFile.fromPath(
  //           'graduation_certificate', userData['certificate'].path);
  //       request.files.add(file);
  //     }
  //     if (userData['nurseID'] != null) {
  //       var file = await http.MultipartFile.fromPath(
  //           'identification_card', userData['nurseID'].path);
  //       request.files.add(file);
  //     }
  //     if (userData['associationCard'] != null) {
  //       var file = await http.MultipartFile.fromPath(
  //           'association_card', userData['associationCard'].path);
  //       request.files.add(file);
  //     }
  //     if (userData['related_job_id'] != null) {
  //       var file = await http.MultipartFile.fromPath(
  //           'related_job_id', userData['related_job_id'].path);
  //       request.files.add(file);
  //     }
  //     if (userData['avatar'] != null) {
  //       var file = await http.MultipartFile.fromPath(
  //           'avatar', userData['avatar'].path);
  //       request.files.add(file);
  //     }
  //     request.headers.addAll(headers);
  //     var streamedResponse = await request.send();
  //     var res = await http.Response.fromStream(streamedResponse);
  //     debugPrint("registerUser: ${res.body}");
  //     var decodedData = jsonDecode(res.body);
  //     if (decodedData['status']) {
  //       await Util.saveLocalData(decodedData);
  //       SetNotification.showNotification(
  //           title: "", msg: translate("toast.welcome"));
  //       return AuthResponse(
  //           user: UserServiceModel.fromJson(decodedData['user']),
  //           msg: translate("toast.signup"),
  //           isSuccess: true);
  //     } else if (decodedData.toString().contains("already")) {
  //       return AuthResponse(
  //           user: null, msg: translate("toast.user_exist"), isFailed: true);
  //     }
  //     return AuthResponse(
  //         user: null, msg: translate("toast.oops"), isFailed: true);
  //   } catch (e) {
  //     return AuthResponse(
  //         user: null, msg: translate("toast.oops"), isFailed: true);
  //   }
  // }
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
      if (userData['email'] != null)
        request.fields['email'] = userData['email'];
      if (userData['phone'] != null)
        request.fields['phone'] = userData['phone'];
      if (userData['password'] != null)
        request.fields['password'] = userData['password'];

      // ✅ Optional fields
      if (userData['city'] != null) request.fields['city'] = userData['city'];
      if (userData['governorate'] != null)
        request.fields['governorate'] = userData['governorate'];
      if (userData['address'] != null)
        request.fields['address'] = userData['address'];
      if (userData['latitude'] != null)
        request.fields['latitude'] = userData['latitude'].toString();
      if (userData['longitude'] != null)
        request.fields['longitude'] = userData['longitude'].toString();
      if (userData['country_code'] != null)
        request.fields['country_code'] = userData['country_code'];
      if (userData['status'] != null)
        request.fields['status'] = userData['status'];
      if (userData['is_male'] != null)
        request.fields['is_male'] = userData['is_male'].toString();
      if (userData['specialties_id'] != null)
        request.fields['specialties_id'] =
            userData['specialties_id'].toString();

      // Nurse/Doctor additional data
      if (userData['languages'] != null)
        request.fields['languages'] = userData['languages'];
      if (userData['education'] != null)
        request.fields['education'] = userData['education'];
      if (userData['publications'] != null)
        request.fields['publications'] = userData['publications'];
      if (userData['courses'] != null)
        request.fields['courses'] = userData['courses'];

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

      // ✅ Check both 'status' and 'success'
      bool isSuccess =
          (decodedData['status'] == true) || (decodedData['success'] == true);

      if (isSuccess) {
        // ✅ Only save data for customers
        if (userType == 'customer') {
          await Util.saveLocalData(decodedData);
          SetNotification.showNotification(
              title: "", msg: translate("toast.welcome"));
        } else {
          // Nurse/Doctor - pending approval
          SetNotification.showNotification(
              title: "", msg: translate("auth.registration_pending"));
        }

        return AuthResponse(
            user: UserServiceModel.fromJson(decodedData['user']),
            msg: translate("toast.signup"),
            isSuccess: true);
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
    var response = await client.post(
      Uri.parse(ApiUrl.SOCIAL_AUTH_URL),
      body: json.encode(data),
      headers: {
        "Content-Type": "application/json",
      },
    );
    var decodedData = json.decode(response.body);
    debugPrint("socialAuthUser: ${response.body}");
    if (response.body.contains("Unauthorized") ||
        response.body.contains("user not found")) {
      return AuthResponse(user: null, msg: translate("toast.sign_wrong"));
    } else if (decodedData['status']) {
      final Map<String, dynamic> bodyData = json.decode(response.body);
      UserServiceModel user = UserServiceModel.fromJson(bodyData['user']);
      await Util.saveLocalData(bodyData);
      SetNotification.showNotification(
          title: "", msg: translate("toast.welcome"));
      return AuthResponse(user: user, msg: translate("toast.signup"));
    } else {
      return AuthResponse(user: null, msg: translate("toast.oops"));
    }
  }
}
