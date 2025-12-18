import 'package:dartz/dartz.dart';
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/core/network/network.dart';
import 'package:icare/features/authentication/data/data_sources/authentication_data_source.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';
import 'package:icare/features/authentication/domain/repositories/auth_service_repository.dart';

class AuthServiceModelRepository implements AuthServiceRepository {
  final AuthServiceRemoteDataSource userServiceRemoteDataSource;
  final NetworkInfo networkInfo;
  AuthServiceModelRepository(
      {required this.userServiceRemoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, AuthResponse>> loginUser(
      Map<String, dynamic> userData) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await userServiceRemoteDataSource.loginUser(userData));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> socialAuthUser(
      Map<String, dynamic> userData) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(
            await userServiceRemoteDataSource.socialAuthUser(userData));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> registerUser(
    Map<String, dynamic> userData,
  ) async {
    return Right(await userServiceRemoteDataSource.registerUser(
      userData,
    ));
  }
}
