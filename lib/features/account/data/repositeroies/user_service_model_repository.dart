import 'package:dartz/dartz.dart';
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/core/network/network.dart';
import 'package:icare/features/account/data/data_sources/account_data_source.dart';
import 'package:icare/features/account/domain/repositories/user_service_repository.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';
import 'package:icare/features/authentication/data/models/user_service_model.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';
import 'package:icare/features/categories/data/models/services.dart';

class UserServiceModelRepository implements UserServiceRepository {
  final UserServiceRemoteDataSource userServiceRemoteDataSource;
  final NetworkInfo networkInfo;
  UserServiceModelRepository(
      {required this.userServiceRemoteDataSource, required this.networkInfo});

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
  Future<Either<Failure, AuthResponse>> changePassword(
      {required Map<String, dynamic> data}) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(
            await userServiceRemoteDataSource.changePassword(data: data));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, UserServiceModel>> getUserFullData(
      {required String userId}) async {
    if (await networkInfo.isConnected()) {
      try {
        return Right(await userServiceRemoteDataSource.fetchUserFullData(
            userId: userId));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateNurseOptions(
      Map<String, dynamic> options) async {
    if (await networkInfo.isConnected()) {
      try {
        await UserServiceRemoteDataSource.updateNurseOptionsValue(
            userData: options);
        return const Right(true);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateDoctorOptions(
      Map<String, dynamic> options) async {
    if (await networkInfo.isConnected()) {
      try {
        await UserServiceRemoteDataSource.updateDoctorOptionsValue(
            userData: options);
        return const Right(true);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<ServicesModel>>> getServices(
      {String? userType}) async {
    if (await networkInfo.isConnected()) {
      try {
        final services = await UserServiceRemoteDataSource.getAllServicesList(
            userType: userType);
        return Right(services);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
