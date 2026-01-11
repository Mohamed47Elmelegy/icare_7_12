import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/setting/domain/entities/specialty_entity.dart';
import 'package:icare/features/setting/domain/repositories/settings_repository.dart';

class GetSpecialtiesUseCase {
  final SettingsRepository repository;

  GetSpecialtiesUseCase({
    required this.repository,
  });

  Future<Either<Failure, List<SpecialtyEntity>>> call() async {
    return await repository.getSpecialties();
  }
}
