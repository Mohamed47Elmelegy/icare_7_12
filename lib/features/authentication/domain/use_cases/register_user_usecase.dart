import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';
import 'package:icare/features/authentication/domain/repositories/auth_service_repository.dart';

class RegisterUserServiceUseCase {
  final AuthServiceRepository authServiceRepository;

  RegisterUserServiceUseCase({
    required this.authServiceRepository,
  });

  Future<Either<Failure, AuthResponse>> call({required Map<String, dynamic> userData}) async {
    return await authServiceRepository.registerUser(userData);
  }
}



