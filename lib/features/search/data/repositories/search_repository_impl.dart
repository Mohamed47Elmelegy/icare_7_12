import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/core/network/network.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:icare/features/search/data/models/search_filter_model.dart';
import 'package:icare/features/search/domain/entities/search_filter_entity.dart';
import 'package:icare/features/search/domain/entities/searchable_entity.dart';
import 'package:icare/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SearchableEntity>>> searchByFilters({
    required SearchFilterEntity filters,
  }) async {
    if (await networkInfo.isConnected()) {
      try {
        final filterModel = SearchFilterModel.fromEntity(filters);
        List<SearchableEntity> result =
            await remoteDataSource.searchByFilters(filters: filterModel);

        if (filters.userType != null && filters.userType!.isNotEmpty) {
          result = result.where((entity) {
            return entity.userData?.userType?.toLowerCase() ==
                filters.userType!.toLowerCase();
          }).toList();
        }

        if (filters.serviceIds != null && filters.serviceIds!.isNotEmpty) {
          result = result.where((entity) {
            // For doctors, check specialtyId instead of servicesList
            if (entity.userData?.userType?.toLowerCase() == 'doctor') {
              if (entity.specialtyId == null) {
                return false;
              }
              // Check if doctor's specialty matches any requested service ID
              final specialtyIdInt = int.tryParse(entity.specialtyId!);
              return specialtyIdInt != null &&
                  filters.serviceIds!.contains(specialtyIdInt);
            }

            // For nurses/assistants, check servicesList
            if (entity.servicesList == null || entity.servicesList!.isEmpty) {
              return false;
            }
            return filters.serviceIds!.any((requestedServiceId) {
              return entity.servicesList!
                  .any((service) => service.id == requestedServiceId);
            });
          }).toList();
        }

        if (filters.latitude != null && filters.longitude != null) {
          final double maxRadius = filters.searchRadius ?? 20.0;
          final List<_EntityWithDistance> entitiesWithDistances = [];

          for (var entity in result) {
            if (entity.userData?.lat != null && entity.userData?.long != null) {
              final double distanceInMeters = Geolocator.distanceBetween(
                filters.latitude!,
                filters.longitude!,
                entity.userData!.lat!,
                entity.userData!.long!,
              );
              final double distanceInKm = distanceInMeters / 1000;

              if (distanceInKm <= maxRadius) {
                // Create a new entity with updated distance
                SearchableEntity updatedEntity = entity;

                // Use copyWith for NurseEntity to update distance
                if (entity is NurseEntity) {
                  updatedEntity = entity.copyWith(
                    distanceKM: distanceInKm,
                    distanceM: distanceInMeters.toInt().toDouble(),
                  );
                }
                // TODO: Add similar copyWith for DoctorEntity when implemented

                entitiesWithDistances
                    .add(_EntityWithDistance(updatedEntity, distanceInKm));
              }
            }
          }

          entitiesWithDistances
              .sort((a, b) => a.distance.compareTo(b.distance));
          result = entitiesWithDistances.map((e) => e.entity).toList();
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

class _EntityWithDistance {
  final SearchableEntity entity;
  final double distance;

  _EntityWithDistance(this.entity, this.distance);
}
