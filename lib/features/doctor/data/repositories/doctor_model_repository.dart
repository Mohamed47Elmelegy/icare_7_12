import 'package:dartz/dartz.dart';
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/core/network/network.dart';
import 'package:icare/features/doctor/data/data_sources/doctor_remote_data_source.dart';
import 'package:icare/features/doctor/domain/entities/doctor_entity.dart';
import 'package:icare/features/doctor/domain/repositories/doctor_repository.dart';

class DoctorsModelRepository implements DoctorsRepository {
  final DoctorsRemoteDataSourceImpl doctorsRemoteDataSourceImpl;
  final NetworkInfo networkInfo;

  DoctorsModelRepository({
    required this.doctorsRemoteDataSourceImpl,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<DoctorEntity>>> getAllDoctors(
      {required Map<String, dynamic> data}) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(
            await doctorsRemoteDataSourceImpl.getAllDoctors(data: data));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> rateDoctor(
      {required Map<String, dynamic> data}) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await doctorsRemoteDataSourceImpl.rateDoctor(data: data));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
