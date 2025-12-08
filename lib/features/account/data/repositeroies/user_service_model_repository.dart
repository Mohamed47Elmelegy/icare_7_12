import 'package:dartz/dartz.dart';
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/core/network/network.dart';
import 'package:icare/features/account/data/data_sources/account_data_source.dart';
import 'package:icare/features/account/domain/repositories/user_service_repository.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';
import 'package:icare/features/authentication/data/models/user_service_model.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';

class UserServiceModelRepository implements UserServiceRepository {
  final UserServiceRemoteDataSource userServiceRemoteDataSource;
  final NetworkInfo networkInfo;
  UserServiceModelRepository({required this.userServiceRemoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, UserService>> getUserData({int? id}) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await userServiceRemoteDataSource.getUserData());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserService>>> getAllUsers() async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await userServiceRemoteDataSource.getAllUsers());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }


  @override
  Future<Either<Failure, UserServiceModel>> updateUserProfile(
      Map<String, dynamic> userData) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await userServiceRemoteDataSource.updateUserProfile(
            userData: userData));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateProfileStatus(
      Map<String, dynamic> userData) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await userServiceRemoteDataSource.updateProfileStatus(
            userData: userData));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> changePassword({required Map<String,dynamic> data}) async{
    if (await networkInfo.isConnected()) {
      try {
        return Right(await userServiceRemoteDataSource.changePassword(data: data));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

}
