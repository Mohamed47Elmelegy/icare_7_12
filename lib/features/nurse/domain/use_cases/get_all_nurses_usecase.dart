import 'package:icare/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/nurse/domain/repositories/nurse_repository.dart';


class GetAllNursesUseCase {
  final NursesRepository nurseRepository;

  GetAllNursesUseCase({required this.nurseRepository});

  Future<Either<Failure, List<NurseEntity>>> call({required Map<String,dynamic> data}) async {
    return await nurseRepository.getAllNurses(data: data);
  }
}


class RateNurseUseCase {
  final NursesRepository nurseRepository;

  RateNurseUseCase({required this.nurseRepository});

  Future<Either<Failure, bool>> call({required Map<String,dynamic> data}) async {
    return await nurseRepository.rateNurse(data: data);
  }
}

