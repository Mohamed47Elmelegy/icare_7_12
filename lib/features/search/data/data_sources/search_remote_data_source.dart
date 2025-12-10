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
      // 🚀 Build URL with query parameters for backend filtering
      String baseUrl = "${ApiUrl.nurses}/1";
      List<String> queryParams = [];

      // Add user_type filter
      if (filters.userType != null && filters.userType!.isNotEmpty) {
        queryParams.add("user_type=${filters.userType}");
      }

      // Add service_ids filter
      if (filters.serviceIds != null && filters.serviceIds!.isNotEmpty) {
        String serviceIdsStr = filters.serviceIds!.join(',');
        queryParams.add("service_ids=$serviceIdsStr");
      }

      // Add location filters for nearby search
      if (filters.latitude != null && filters.longitude != null) {
        queryParams.add("lat=${filters.latitude}");
        queryParams.add("long=${filters.longitude}");
        // Optional: add radius parameter (default 5km)
        queryParams.add("radius=5");
      }

      // Add search text filter
      if (filters.searchText != null && filters.searchText!.isNotEmpty) {
        queryParams.add("search=${Uri.encodeComponent(filters.searchText!)}");
      }

      // Build final URL
      String url = baseUrl;
      if (queryParams.isNotEmpty) {
        url = "$baseUrl?${queryParams.join('&')}";
      }

      print("🌐 API Request URL: $url");

      final response = await client.get(
        Uri.parse(url),
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
