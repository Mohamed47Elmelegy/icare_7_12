import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/account/domain/repositories/user_service_repository.dart';

class UpdateNurseOptionsUseCase {
  final UserServiceRepository repository;

  UpdateNurseOptionsUseCase({
    required this.repository,
  });

  Future<Either<Failure, bool>> call({
    required Map<String, dynamic> options,
  }) async {
    return await repository.updateNurseOptions(options);
  }
}
