import 'package:icare/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:icare/features/locations/domain/entities/location_entity.dart';

abstract class LocationsRepository {
  Future<Either<Failure, bool>> addNewLocation(
      {required Map<String, dynamic> data});
  Future<Either<Failure, bool>> removeLocation({required int addressId});
  Future<Either<Failure, bool>> updateLocation(
      {required Map<String, dynamic> data});
  Future<Either<Failure, AddressEntity>> fetchAllLocations();
}
