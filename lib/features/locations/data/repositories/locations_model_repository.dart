import 'package:icare/core/error/exception.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/core/network/network.dart';
import 'package:icare/features/locations/data/models/location_model.dart';
import 'package:dartz/dartz.dart';
import 'package:icare/features/locations/data/data_sources/location_remote_data_source.dart';
import 'package:icare/features/locations/domain/repositories/location_repository.dart';

class LocationsModelRepository implements LocationsRepository {
  final LocationRemoteDataSourceImpl locationRemoteDataSource;
  final NetworkInfo networkInfo;

  LocationsModelRepository(
      {required this.locationRemoteDataSource, required this.networkInfo});


  @override
  Future<Either<Failure, bool>> addNewLocation({required Map<String, dynamic> data}) async{
    if (await networkInfo.isConnected()) {
      try {
        return Right(await locationRemoteDataSource.addNewLocation(data: data));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, AddressModel>> fetchAllLocations() async{
    if (await networkInfo.isConnected()) {
      try {
        return Right(await locationRemoteDataSource.fetchAllLocations());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> removeLocation({required int addressId}) async{
    if (await networkInfo.isConnected()) {
      try {
        return Right(await locationRemoteDataSource.removeLocation(addressId: addressId));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateLocation({required Map<String, dynamic> data}) async{
    if (await networkInfo.isConnected()) {
      try {
        return Right(await locationRemoteDataSource.updateLocation(data: data));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

}