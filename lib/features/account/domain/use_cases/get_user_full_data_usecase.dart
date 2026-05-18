import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/account/domain/repositories/user_service_repository.dart';
import 'package:icare/features/authentication/data/models/user_service_model.dart';

class GetUserFullDataUseCase {
  final UserServiceRepository repository;

  GetUserFullDataUseCase({required this.repository});

  Future<Either<Failure, UserServiceModel>> call(
      {required String userId}) async {
    return await repository.getUserFullData(userId: userId);
  }
}
