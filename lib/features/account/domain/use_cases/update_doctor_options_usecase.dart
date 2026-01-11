import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/account/domain/repositories/user_service_repository.dart';

class UpdateDoctorOptionsUseCase {
  final UserServiceRepository repository;

  UpdateDoctorOptionsUseCase({
    required this.repository,
  });

  Future<Either<Failure, bool>> call({
    required Map<String, dynamic> options,
  }) async {
    return await repository.updateDoctorOptions(options);
  }
}
