import 'dart:convert';

import 'package:icare/core/error/exception.dart';
import 'package:icare/core/strings/api/api_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icare/features/locations/data/models/location_model.dart';

abstract class LocationRemoteDataSourceImpl {
  Future<bool> addNewLocation({required Map<String, dynamic> data});
  Future<bool> removeLocation({required int addressId});
  Future<bool> updateLocation({required Map<String, dynamic> data});
  Future<AddressModel> fetchAllLocations();
}

class LocationRemoteDataSource extends LocationRemoteDataSourceImpl {
  final http.Client client;
  LocationRemoteDataSource({required this.client});

  @override
  Future<bool> addNewLocation({required Map<String, dynamic> data}) async {
    var response = await client.post(Uri.parse(ApiUrl.ADD_NEW_ADDRESS),
        headers: ApiUrl.headerAuth, body: jsonEncode(data));
    debugPrint("addNewLocation: ${response.body}");
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return body['status'] ?? false;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> removeLocation({required int addressId}) async {
    var response = await client.delete(
        Uri.parse("${ApiUrl.REMOVE_ADDRESS}$addressId"),
        headers: ApiUrl.headerAuth);
    debugPrint("removeLocation: ${response.body}");
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return body['message'].toString().contains("done") ? true : false;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> updateLocation({required Map<String, dynamic> data}) async {
    // var response = await client.put(Uri.parse("${ApiUrl.UPDATE_ADDRESS}${data['id']}"),
    //     headers: ApiUrl.headerAuth,body: jsonEncode(data));
    var response = await client.post(Uri.parse(ApiUrl.ADD_NEW_ADDRESS),
        headers: ApiUrl.headerAuth, body: jsonEncode(data));
    debugPrint("updateLocation: ${response.body}");
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return body['message'].toString().contains("done") ? true : false;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AddressModel> fetchAllLocations() async {
    var response = await client.get(Uri.parse(ApiUrl.FETCH_ADDRESS),
        headers: ApiUrl.headerAuth);
    debugPrint("fetchAllLocations: ${response.body}");
    var decodedData = json.decode(response.body.toString());
    if (response.statusCode == 200 && decodedData['status']) {
      return AddressModel.fromJson(decodedData);
    } else {
      throw ServerException();
    }
  }
}
