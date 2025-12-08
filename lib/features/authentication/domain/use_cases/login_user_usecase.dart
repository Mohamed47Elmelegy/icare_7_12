import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';
import 'package:icare/features/authentication/domain/repositories/auth_service_repository.dart';


class LoginUserServiceUseCase {
  final AuthServiceRepository authServiceRepository;

  LoginUserServiceUseCase({
    required this.authServiceRepository,
  });

  Future<Either<Failure, AuthResponse>> call(
      {required Map<String,dynamic> data}) async {
    return await authServiceRepository.loginUser(data);
  }
}
