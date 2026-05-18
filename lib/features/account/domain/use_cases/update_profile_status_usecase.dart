import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/account/domain/repositories/user_service_repository.dart';

class UpdateProfileStatusUseCase {
  final UserServiceRepository userServiceRepository;

  UpdateProfileStatusUseCase({required this.userServiceRepository});

  Future<Either<Failure, bool>> call(Map<String, dynamic> userData) async {
    return await userServiceRepository.updateProfileStatus(userData);
  }
}
