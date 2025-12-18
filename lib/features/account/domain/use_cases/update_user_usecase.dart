import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';
import 'package:icare/features/account/domain/repositories/user_service_repository.dart';

class UpdateUserServiceUseCase {
  final UserServiceRepository userServiceRepository;

  UpdateUserServiceUseCase({
    required this.userServiceRepository,
  });

  Future<Either<Failure, UserService>> call(
      {required Map<String, dynamic> userData}) async {
    return await userServiceRepository.updateUserProfile(userData);
  }
}

class UpdateProfileStatusUseCase {
  final UserServiceRepository userServiceRepository;

  UpdateProfileStatusUseCase({
    required this.userServiceRepository,
  });

  Future<Either<Failure, bool>> call(
      {required Map<String, dynamic> userData}) async {
    return await userServiceRepository.updateProfileStatus(userData);
  }
}
