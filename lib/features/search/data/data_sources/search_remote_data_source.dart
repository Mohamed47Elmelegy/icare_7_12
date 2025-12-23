import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/strings/api/api_url.dart';
import 'package:icare/features/search/data/models/search_filter_model.dart';
import 'package:icare/features/search/data/models/searchable_model_factory.dart';
import 'package:icare/features/search/domain/entities/searchable_entity.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchableEntity>> searchByFilters({
    required SearchFilterModel filters,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final http.Client client;

  SearchRemoteDataSourceImpl({required this.client});

  @override
  Future<List<SearchableEntity>> searchByFilters({
    required SearchFilterModel filters,
  }) async {
    try {
      // 🚀 Multi-Page Pagination Strategy
      // Strategy: Request wider radius from backend (1.5x), then filter precisely in frontend
      // Why: Backend filters at radius level, we need more data to find results at different distances
      const int maxPages = 3; // Fetch up to 3 pages (~60-100 results)
      const int minResultsTarget = 50; // Stop early if we have enough results
      List<SearchableEntity> allResults = [];

      final double requestedRadius = filters.searchRadius ?? 20.0;
      print(
          "📦 Fetching up to $maxPages pages (target: $minResultsTarget+ results)...");
      print("   └─ Frontend filter: ≤${requestedRadius}km");
      print(
          "   └─ Backend request: ≤${(requestedRadius * 1.5).toInt()}km (wider for more data)");

      for (int page = 1; page <= maxPages; page++) {
        print("📄 Fetching page $page...");
        try {
          // Build URL with query parameters for each page
          String baseUrl = "${ApiUrl.nurses}/$page";
          if (filters.userType == "doctor") {
            baseUrl = "${ApiUrl.doctors}/$page";
          }

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
            // Request wider radius from backend to get more results
            // Frontend will filter and sort by distance up to maxRadius (default 20km)
            final double backendRadius =
                (filters.searchRadius ?? 20.0) * 1.5; // 1.5x for buffer
            queryParams.add(
                "radius=${backendRadius.toInt()}"); // e.g., 30km for 20km search
          }

          // Add search text filter
          if (filters.searchText != null && filters.searchText!.isNotEmpty) {
            queryParams
                .add("search=${Uri.encodeComponent(filters.searchText!)}");
          }

          // Build final URL
          String url = baseUrl;
          if (queryParams.isNotEmpty) {
            url = "$baseUrl?${queryParams.join('&')}";
          }

          if (page == 1) {
            print("🌐 API Base URL: $url");
          }

          final response = await client
              .get(
            Uri.parse(url),
            headers: ApiUrl.headerAuth,
          )
              .timeout(
            const Duration(seconds: 30), // Increased timeout for slow networks
            onTimeout: () {
              print("   ⏱️ Page $page timed out after 30 seconds");
              throw Exception('Request timeout');
            },
          );

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

            // If empty page, stop fetching more pages
            if (dataList.isEmpty) {
              print("   ⏸️ Page $page is empty, stopping pagination");
              break;
            }

            List<SearchableEntity> pageResults =
                dataList.map<SearchableEntity>((model) {
              return SearchableModelFactory.fromJson(
                model,
                filters.userType ??
                    'nurse', // Default to nurse if not specified
              );
            }).toList();

            allResults.addAll(pageResults);
            print(
                "   ✅ Page $page: ${pageResults.length} results (Total: ${allResults.length})");

            // Smart stopping conditions:

            // 1. If we got way more than expected, backend is returning all data
            if (pageResults.length > 100) {
              print(
                  "   🎯 Large page detected (${pageResults.length} results)");
              print(
                  "   🏁 Backend returned comprehensive data, stopping pagination");
              break;
            }

            // 2. If we have enough results, stop early
            if (allResults.length >= minResultsTarget) {
              print(
                  "   🎯 Target reached: ${allResults.length} results (>= $minResultsTarget)");
              print("   🏁 Stopping pagination early");
              break;
            }

            // 3. If we got less than 20 results, likely the last page
            if (pageResults.length < 20) {
              print(
                  "   🏁 Last page reached (${pageResults.length} results < 20)");
              break;
            }

            // Continue to next page
            print("   ➡️ Continuing to page ${page + 1}...");
          } else {
            print("   ⚠️ Page $page failed with status ${response.statusCode}");
            // Don't break, continue with what we have
          }
        } catch (pageError) {
          // Catch individual page errors, don't fail entire search
          String errorMsg = pageError.toString();
          String truncatedError = errorMsg.length > 100
              ? '${errorMsg.substring(0, 100)}...'
              : errorMsg;
          print("   ⚠️ Page $page error: $truncatedError");
          print(
              "   ↪️ Continuing with ${allResults.length} results from previous pages");
          break; // Stop trying more pages after first error
        }
      }

      print("📦 Multi-page fetch complete: ${allResults.length} total results");

      if (allResults.isNotEmpty) {
        return allResults;
      }

      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }
}
