import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/strings/api/api_url.dart';
import 'package:icare/features/nurse/data/models/nurse_model.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';

abstract class NursesRemoteDataSourceImpl {
  Future<List<NurseEntity>> getAllNurses({required Map<String, dynamic> data});
  Future<bool> rateNurse({required Map<String, dynamic> data});
}

class NursesRemoteDataSource implements NursesRemoteDataSourceImpl {
  final http.Client client;
  NursesRemoteDataSource({required this.client});
  @override
  Future<List<NurseEntity>> getAllNurses(
      {required Map<String, dynamic> data}) async {
    var response = await client.get(
        Uri.parse("${ApiUrl.nurses}/${data['page']}"),
        headers: ApiUrl.headerAuth);
    // getAllNurses

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      List<NurseEntity> list = body['data'].map<NurseModel>((model) {
        return NurseModel.fromJson(model);
      }).toList();
      return list;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> rateNurse({required Map<String, dynamic> data}) async {
    var response = await client.post(Uri.parse(ApiUrl.RATE_NURSE), body: data);
    // rateNurse

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['status'];
    } else {
      throw ServerException();
    }
  }
}
