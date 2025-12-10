import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/strings/api/api_url.dart';
import 'package:icare/features/nurse/data/models/nurse_model.dart';
import 'package:icare/features/search/data/models/search_filter_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<NurseModel>> searchByFilters({
    required SearchFilterModel filters,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final http.Client client;

  SearchRemoteDataSourceImpl({required this.client});

  @override
  Future<List<NurseModel>> searchByFilters({
    required SearchFilterModel filters,
  }) async {
    try {
      // ✅ Old approach: Backend returns all nurses, frontend filters
      // Just call the basic nurses endpoint like before
      final response = await client.get(
        Uri.parse("${ApiUrl.nurses}/1"),
        headers: ApiUrl.headerAuth,
      );

      print("📥 API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        // Handle both paginated and non-paginated responses
        List<dynamic> dataList;
        if (body['data'] is List) {
          dataList = body['data'];
        } else if (body is List) {
          dataList = body;
        } else {
          dataList = [];
        }

        List<NurseModel> list = dataList.map<NurseModel>((model) {
          return NurseModel.fromJson(model);
        }).toList();

        print("🔍 Search API returned ${list.length} results");
        return list;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
