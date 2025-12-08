import 'package:icare/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';

abstract class NursesRepository {
  Future<Either<Failure, List<NurseEntity>>> getAllNurses({required Map<String,dynamic> data});
  Future<Either<Failure, bool>> rateNurse({required Map<String,dynamic> data});
}
