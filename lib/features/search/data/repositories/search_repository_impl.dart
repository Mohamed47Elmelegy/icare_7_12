import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/core/network/network.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:icare/features/search/data/models/search_filter_model.dart';
import 'package:icare/features/search/domain/entities/search_filter_entity.dart';
import 'package:icare/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<NurseEntity>>> searchByFilters({
    required SearchFilterEntity filters,
  }) async {
    if (await networkInfo.isConnected()) {
      try {
        final filterModel = SearchFilterModel.fromEntity(filters);

        // 🚀 Get nurses from backend (backend doesn't support query params filtering yet)
        var result =
            await remoteDataSource.searchByFilters(filters: filterModel);

        print("📥 Backend returned ${result.length} total results");

        // ⚠️ Backend doesn't filter by query parameters yet
        // Apply frontend filtering as fallback

        // Filter by user type
        if (filters.userType != null && filters.userType!.isNotEmpty) {
          result = result.where((nurse) {
            return nurse.userData?.userType?.toLowerCase() ==
                filters.userType!.toLowerCase();
          }).toList();
          print("✅ After userType filter: ${result.length} results");
        }

        // Filter by service IDs
        if (filters.serviceIds != null && filters.serviceIds!.isNotEmpty) {
          result = result.where((nurse) {
            if (nurse.servicesList == null || nurse.servicesList!.isEmpty) {
              return false;
            }
            // Check if nurse provides ANY of the requested services
            return filters.serviceIds!.any((requestedServiceId) {
              return nurse.servicesList!.any((nurseService) {
                return nurseService.id == requestedServiceId;
              });
            });
          }).toList();
          print("✅ After services filter: ${result.length} results");
        }

        // Filter by location (distance-based)
        if (filters.latitude != null && filters.longitude != null) {
          result = result.where((nurse) {
            // Check if nurse has location data
            if (nurse.userData?.lat == null || nurse.userData?.long == null) {
              return false;
            }

            // Calculate distance between user and nurse
            double distanceInMeters = _calculateDistance(
              filters.latitude!,
              filters.longitude!,
              nurse.userData!.lat!,
              nurse.userData!.long!,
            );

            // Convert to kilometers
            double distanceInKm = distanceInMeters / 1000;

            // Filter within 5km radius
            return distanceInKm <= 5.0;
          }).toList();
          print(
              "✅ After location filter (5km radius): ${result.length} results");
        }

        print("🎯 Final filtered results: ${result.length}");
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  /// Calculate distance between two coordinates in meters
  double _calculateDistance(
    double startLat,
    double startLong,
    double endLat,
    double endLong,
  ) {
    return Geolocator.distanceBetween(
      startLat,
      startLong,
      endLat,
      endLong,
    );
  }
}
