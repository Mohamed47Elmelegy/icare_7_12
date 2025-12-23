import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/account/domain/repositories/user_service_repository.dart';
import 'package:icare/features/authentication/data/models/user_service_model.dart';

class GetPatientDetailsUseCase {
  final UserServiceRepository repository;

  GetPatientDetailsUseCase(this.repository);

  Future<Either<Failure, UserServiceModel>> call({required String userId}) {
    return repository.getUserFullData(userId: userId);
  }
}
