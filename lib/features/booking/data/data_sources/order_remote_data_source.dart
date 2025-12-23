import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/strings/api/api_url.dart';
import 'package:icare/core/utils/set_notification.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/data/data_sources/account_data_source.dart';
import 'package:icare/features/booking/data/models/order_model.dart';
import 'package:icare/features/booking/data/models/order_response.dart';

abstract class OrderRemoteDataSourceImpl {
  Future<List<OrderModel>> getAllOrder();
  Future<OrderResponse> addOrder({required Map<String, dynamic> data});
  Future<OrderResponse> updateOrder(
      {required Map<String, dynamic> data, File? fileR});
  Future<bool> cancelOrder({required int orderId});

  Future<OrderResponse> sendRequest({required Map<String, dynamic> data});
}

class OrderRemoteDataSource implements OrderRemoteDataSourceImpl {
  final http.Client client;
  OrderRemoteDataSource({required this.client});
  @override
  Future<List<OrderModel>> getAllOrder() async {
    var response = await client.get(
        Uri.parse("${ApiUrl.FETCH_ALL_ORDERS}/${Util.getUserID()}"),
        headers: ApiUrl.headerAuth);
    debugPrint("getAllOrder: ${response.body}");
    final decodedData = json.decode(response.body);
    if (decodedData['success']) {
      List<OrderModel> orders =
          decodedData['data'].map<OrderModel>((orderModel) {
        return OrderModel.fromJson(orderModel);
      }).toList();
      return orders;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<OrderResponse> addOrder({required Map<String, dynamic> data}) async {
    final response = await client.post(Uri.parse(ApiUrl.ADD_ORDER),
        body: json.encode(data), headers: ApiUrl.headerAuth);
    debugPrint("addOrder: ${response.body}");
    var decodedData = jsonDecode(response.body);
    if (decodedData['success'] == true) {
      // Show local notification to patient
      SetNotification.showNotification(
          title: "", msg: translate("toast.order_send"));

      // Send notification to nurse
      if (data['nurse_id'] != null) {
        try {
          await UserServiceRemoteDataSource.sendNotification(data: {
            'user_id': data['nurse_id'].toString(),
            'msg': translate("notification.new_booking_request"),
          });
          debugPrint("✅ Notification sent to nurse: ${data['nurse_id']}");
        } catch (e) {
          debugPrint("❌ Failed to send notification to nurse: $e");
        }
      }

      return OrderResponse(
          state: true,
          msg: decodedData['message'] ?? "",
          orderID: decodedData['order_id'].toString());
    } else {
      String msg = decodedData['message'].toString().contains("busy")
          ? translate("icare.nurse_is_busy")
          : decodedData['message'].toString();
      return OrderResponse(state: false, msg: msg, orderID: "");
    }
  }

  @override
  Future<OrderResponse> updateOrder(
      {required Map<String, dynamic> data, File? fileR}) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(ApiUrl.UPDATE_ORDER_STATUS));
    var headers = ApiUrl.headerAuth;

    // Required fields
    if (data['status'] != null) {
      request.fields['status'] = data['status'].toString();
    }
    if (data['booking_id'] != null) {
      request.fields['booking_id'] = data['booking_id'].toString();
    }

    // // Optional patient vitals fields (sent only when completing booking)
    if (data['heart_rate'] != null) {
      request.fields['heart_rate'] = data['heart_rate'].toString();
    }
    if (data['blood_pressure'] != null) {
      request.fields['blood_pressure'] = data['blood_pressure'].toString();
    }
    if (data['height'] != null) {
      request.fields['height'] = data['height'].toString();
    }
    if (data['weight'] != null) {
      request.fields['weight'] = data['weight'].toString();
    }
    if (data['pulse_rate'] != null) {
      request.fields['pulse_rate'] = data['pulse_rate'].toString();
    }

    request.headers.addAll(headers);
    var streamedResponse = await request.send();
    var res = await http.Response.fromStream(streamedResponse);
    // debugPrint("updateOrder: ${res.body}");
    if (res.body.toString().contains("true")) {
      SetNotification.showNotification(
          title: "", msg: translate("toast.update_user_data"));
      return OrderResponse(state: true, msg: "success", orderID: "");
    } else if (res.body.toString().contains("edit patient")) {
      return OrderResponse(
          state: false, msg: translate("icare.must_edit"), orderID: "");
    } else {
      return OrderResponse(
          state: false, msg: translate("toast.oops"), orderID: "");
    }
  }

  @override
  Future<bool> cancelOrder({required int orderId}) async {
    final response = await client.delete(
      Uri.parse(ApiUrl.CANCEL_ORDER),
      headers: ApiUrl.headerAuth,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException();
    }
  }

  static Future<bool> giveAccessEditProfile() async {
    try {
      final response = await http.post(Uri.parse(ApiUrl.GIVE_ACCESS), headers: {
        'Content-Type': 'application/json',
        'ID': Util.getUserID().toString(),
      });
      debugPrint("giveAccessEditProfile: ${response.body}");
      return response.body.toString().contains("true");
    } catch (e) {
      debugPrint("giveAccessEditProfile: $e");
      return false;
    }
  }

  @override
  Future<OrderResponse> sendRequest(
      {required Map<String, dynamic> data}) async {
    try {
      final response = await client.post(Uri.parse(ApiUrl.SEND_REQUEST),
          body: json.encode(data), headers: ApiUrl.headerAuth);
      debugPrint("sendRequest: ${response.body}");
      var decodedData = jsonDecode(response.body);
      if (decodedData['success'] == true) {
        SetNotification.showNotification(
            title: "", msg: translate("toast.order_send"));
        return OrderResponse(
            state: true, msg: decodedData['message'] ?? "", orderID: "");
      } else {
        String msg = decodedData['message'].toString().contains("busy")
            ? translate("icare.nurse_is_busy")
            : decodedData['message'].toString();
        return OrderResponse(state: false, msg: msg, orderID: "");
      }
    } catch (e) {
      debugPrint("sendRequestDataSourceError: $e");
      return OrderResponse(state: false, msg: '$e', orderID: "");
    }
  }

  static Future<dynamic> acceptOffer(
      {required Map<String, dynamic> data}) async {
    try {
      final response = await http.post(Uri.parse(ApiUrl.ACCEPT_OFFER),
          headers: ApiUrl.headerAuth, body: jsonEncode(data));
      debugPrint("acceptOffer: ${response.body}");
      var decodedData = jsonDecode(response.body);
      String msg = (decodedData['message'] == null
          ? translate('toast.oops')
          : (decodedData['message'].toString().contains('nurse is busy')
              ? translate('icare.nurse_is_busy')
              : decodedData['message'].toString()));
      return decodedData['success'] == true ? true : msg;
    } catch (e) {
      debugPrint("acceptOffer: $e");
      return translate('toast.oops');
    }
  }
}
