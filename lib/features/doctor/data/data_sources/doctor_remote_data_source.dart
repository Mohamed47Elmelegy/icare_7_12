import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/strings/api/api_url.dart';
import 'package:icare/features/doctor/data/models/doctor_model.dart';
import 'package:icare/features/doctor/domain/entities/doctor_entity.dart';

abstract class DoctorsRemoteDataSourceImpl {
  Future<List<DoctorEntity>> getAllDoctors({required Map<String, dynamic> data});
  Future<bool> rateDoctor({required Map<String, dynamic> data});
}

class DoctorsRemoteDataSource implements DoctorsRemoteDataSourceImpl {
  final http.Client client;
  DoctorsRemoteDataSource({required this.client});

  @override
  Future<List<DoctorEntity>> getAllDoctors({required Map<String, dynamic> data}) async {
    var response = await client.get(Uri.parse("${ApiUrl.doctors}/${data['page']}"), headers: ApiUrl.headerAuth);
    debugPrint("getAllDoctors?page=${data['page']}  ${response.body}");
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      List<DoctorEntity> list = body['data'].map<DoctorModel>((model) {
        return DoctorModel.fromJson(model);
      }).toList();
      return list;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> rateDoctor({required Map<String, dynamic> data}) async {
    var response = await client.post(Uri.parse(ApiUrl.RATE_DOCTOR), body: data);
    debugPrint("rateDoctor ${response.body}");
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['status'];
    } else {
      throw ServerException();
    }
  }
}
