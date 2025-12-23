import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';

import '../../../authentication/data/models/user_service_model.dart';

abstract class UserServiceRepository {
  Future<Either<Failure, UserService>> getUserData();
  Future<Either<Failure, List<UserService>>> getAllUsers();
  Future<Either<Failure, AuthResponse>> changePassword(
      {required Map<String, dynamic> data});
  Future<Either<Failure, UserService>> updateUserProfile(
      Map<String, dynamic> userData);
  Future<Either<Failure, bool>> updateProfileStatus(
      Map<String, dynamic> userData);
  Future<Either<Failure, UserServiceModel>> getUserFullData(
      {required String userId});
}
