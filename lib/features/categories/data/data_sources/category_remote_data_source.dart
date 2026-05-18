import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/strings/api/api_url.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/categories/data/models/allergies.dart';
import 'package:icare/features/categories/data/models/categories_model.dart';
import 'package:icare/features/categories/data/models/publications_model.dart';
import 'package:icare/features/categories/data/models/slider_model.dart';

abstract class CategoryRemoteDataSourceImpl {
  Future<List<CategoriesModel>> getAllCategory();
  Future<List<AllergiesModel>> getAllAllergies();
  Future<List<String>> getPatientAllergies(String userId);
  Future<List<PublicationsModel>> getAllPublications();
  Future<List<SliderModel>> getAllSliders();
}

class CategoryRemoteDataSource implements CategoryRemoteDataSourceImpl {
  final http.Client client;
  CategoryRemoteDataSource({required this.client});
  @override
  Future<List<CategoriesModel>> getAllCategory() async {
    var response = await client.get(Uri.parse(ApiUrl.CATEGORIES_URL));
    // debugPrint("getAllCategory ${response.body}");
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      List<CategoriesModel> categories =
          body['data'].map<CategoriesModel>((categoryModel) {
        return CategoriesModel.fromJson(categoryModel);
      }).toList();
      return categories;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<AllergiesModel>> getAllAllergies() async {
    var response = await client.get(Uri.parse(ApiUrl.ALLERGIES));
    // getAllAllergies

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      List<AllergiesModel> list = body['data'].map<AllergiesModel>((model) {
        return AllergiesModel.fromJsonAllergies(model);
      }).toList();
      return list;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<String>> getPatientAllergies(String userId) async {
    var response = await client.get(
      Uri.parse(ApiUrl.ALLERGIES),
      headers: {
        'Content-Type': 'application/json',
        'ID': userId,
        'lat': Util.getLatitude().toString(),
        'long': Util.getLongitude().toString(),
        if (Util.checkUser()) 'Authorization': 'Bearer ${Util.getToken()}',
      },
    );
    // getPatientAllergies

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['data'] != null && body['data'] is List) {
        return List<String>.from(
          body['data'].map((model) => model['value']?.toString() ?? ''),
        );
      }
      return [];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SliderModel>> getAllSliders() async {
    var response = await client.get(Uri.parse(ApiUrl.SLIDERS_URL));
    // debugPrint("getAllSliders: ${response.body}");
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      List<SliderModel> sliders = body['data'].map<SliderModel>((model) {
        return SliderModel.fromJson(model);
      }).toList();
      return sliders;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<PublicationsModel>> getAllPublications() async {
    var response = await client
        .get(Uri.parse("${ApiUrl.PUBLICATIONS}/${Util.getUserType()}"));
    // getAllPublications

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return PublicationsModel.listDFromJson(body['data']);
    } else {
      throw ServerException();
    }
  }
}
