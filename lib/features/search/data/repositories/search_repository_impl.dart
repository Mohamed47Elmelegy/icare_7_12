import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/core/network/network.dart';
import 'package:icare/features/nurse/data/models/nurse_model.dart';
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
        List<NurseModel> result =
            await remoteDataSource.searchByFilters(filters: filterModel);

        if (filters.userType != null && filters.userType!.isNotEmpty) {
          result = result.where((nurse) {
            return nurse.userData?.userType?.toLowerCase() ==
                filters.userType!.toLowerCase();
          }).toList();
        }

        if (filters.serviceIds != null && filters.serviceIds!.isNotEmpty) {
          result = result.where((nurse) {
            if (nurse.servicesList == null || nurse.servicesList!.isEmpty) {
              return false;
            }
            return filters.serviceIds!.any((requestedServiceId) {
              return nurse.servicesList!
                  .any((nurseService) => nurseService.id == requestedServiceId);
            });
          }).toList();
        }

        if (filters.latitude != null && filters.longitude != null) {
          final double maxRadius = filters.searchRadius ?? 20.0;
          final List<_NurseWithDistance> nursesWithDistances = [];

          for (var nurse in result) {
            if (nurse.userData?.lat != null && nurse.userData?.long != null) {
              final double distanceInMeters = Geolocator.distanceBetween(
                filters.latitude!,
                filters.longitude!,
                nurse.userData!.lat!,
                nurse.userData!.long!,
              );
              final double distanceInKm = distanceInMeters / 1000;

              if (distanceInKm <= maxRadius) {
                nursesWithDistances
                    .add(_NurseWithDistance(nurse, distanceInKm));
              }
            }
          }

          nursesWithDistances.sort((a, b) => a.distance.compareTo(b.distance));
          result = nursesWithDistances.map((e) => e.nurse).toList();
        }

        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

class _NurseWithDistance {
  final NurseModel nurse;
  final double distance;

  _NurseWithDistance(this.nurse, this.distance);
}
