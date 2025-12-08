
import 'package:dartz/dartz.dart';
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/core/network/network.dart';
import 'package:icare/features/nurse/data/data_sources/nurse_remote_data_source.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/nurse/domain/repositories/nurse_repository.dart';

class NursesModelRepository implements NursesRepository {
  final NursesRemoteDataSourceImpl nursesRemoteDataSourceImpl;
  final NetworkInfo networkInfo;
  NursesModelRepository(
      {required this.nursesRemoteDataSourceImpl, required this.networkInfo});
  @override
  Future<Either<Failure, List<NurseEntity>>> getAllNurses({required Map<String,dynamic> data}) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await nursesRemoteDataSourceImpl.getAllNurses(data: data));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> rateNurse({required Map<String,dynamic> data}) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await nursesRemoteDataSourceImpl.rateNurse(data: data));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }




}
