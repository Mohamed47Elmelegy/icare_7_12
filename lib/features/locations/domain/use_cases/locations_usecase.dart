import 'package:icare/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:icare/features/locations/domain/entities/location_entity.dart';
import 'package:icare/features/locations/domain/repositories/location_repository.dart';

class FetchUserLocationsUseCase{
  final LocationsRepository locationsRepository;
  FetchUserLocationsUseCase({required this.locationsRepository});

  Future<Either<Failure , AddressEntity>> call()async{
    return await locationsRepository.fetchAllLocations();
  }
}

class AddLocationUseCase{
  final LocationsRepository locationsRepository;
  AddLocationUseCase({required this.locationsRepository});

  Future<Either<Failure , bool>> call({required Map<String,dynamic> data})async{
    return await locationsRepository.addNewLocation(data: data);
  }
}

class UpdateLocationUseCase{
  final LocationsRepository locationsRepository;
  UpdateLocationUseCase({required this.locationsRepository});

  Future<Either<Failure , bool>> call({required Map<String,dynamic> data})async{
    return await locationsRepository.updateLocation(data: data);
  }
}

class RemoveLocationUseCase{
  final LocationsRepository locationsRepository;
  RemoveLocationUseCase({required this.locationsRepository});

  Future<Either<Failure , bool>> call({required int addressId})async{
    return await locationsRepository.removeLocation(addressId: addressId);
  }
}
