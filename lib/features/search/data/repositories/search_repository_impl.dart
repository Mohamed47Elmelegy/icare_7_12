import 'package:dartz/dartz.dart';
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

        // Get all nurses from backend (old approach)
        var result =
            await remoteDataSource.searchByFilters(filters: filterModel);

        // ✅ Apply frontend filtering (old approach like gender)
        // Filter by userType
        if (filters.userType != null && filters.userType!.isNotEmpty) {
          result = result.where((nurse) {
            return nurse.userData?.userType?.toLowerCase() ==
                filters.userType!.toLowerCase();
          }).toList();
          print(
              "🔍 Filtered by userType '${filters.userType}': ${result.length} nurses");
        }

        // Filter by serviceIds
        if (filters.serviceIds != null && filters.serviceIds!.isNotEmpty) {
          result = result.where((nurse) {
            if (nurse.servicesList == null || nurse.servicesList!.isEmpty) {
              return false;
            }
            return nurse.servicesList!
                .any((service) => filters.serviceIds!.contains(service.id));
          }).toList();
          print(
              "🔍 Filtered by services ${filters.serviceIds}: ${result.length} nurses");
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
