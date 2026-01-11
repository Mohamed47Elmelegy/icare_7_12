import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';
import 'package:icare/features/categories/data/models/services.dart';

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

  /// Update nurse professional options (languages, education, publications, courses, services)
  Future<Either<Failure, bool>> updateNurseOptions(
      Map<String, dynamic> options);

  /// Update doctor professional options (languages, education, publications, courses, specialties)
  Future<Either<Failure, bool>> updateDoctorOptions(
      Map<String, dynamic> options);

  /// Get list of available services filtered by user type
  Future<Either<Failure, List<ServicesModel>>> getServices({String? userType});
}
