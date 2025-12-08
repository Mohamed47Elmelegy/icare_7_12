
import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';

abstract class AuthServiceRepository {
  Future<Either<Failure, AuthResponse>> registerUser(Map<String, dynamic> userData);
  Future<Either<Failure, AuthResponse>> loginUser(Map<String, dynamic> userData);
  Future<Either<Failure, AuthResponse>> socialAuthUser(Map<String, dynamic> userData);
}
