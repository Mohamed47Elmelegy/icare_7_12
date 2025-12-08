import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/account/domain/repositories/user_service_repository.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';


class GetAllUsersUseCase {
  final UserServiceRepository userServiceRepository;

  GetAllUsersUseCase({
    required this.userServiceRepository,
  });

  Future<Either<Failure, List<UserService>>> call() async {
    return await userServiceRepository.getAllUsers();
  }
}
