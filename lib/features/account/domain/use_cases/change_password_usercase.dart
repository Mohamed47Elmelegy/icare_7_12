import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/account/domain/repositories/user_service_repository.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';


class ChangePasswordUseCase {
  final UserServiceRepository userServiceRepository;

  ChangePasswordUseCase({
    required this.userServiceRepository,
  });

  Future<Either<Failure, AuthResponse>> call({required Map<String,dynamic> data}) async {
    return await userServiceRepository.changePassword(data: data);
  }
}
