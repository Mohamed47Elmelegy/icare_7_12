import 'package:icare/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:icare/features/doctor/domain/entities/doctor_entity.dart';

abstract class DoctorsRepository {
  Future<Either<Failure, List<DoctorEntity>>> getAllDoctors(
      {required Map<String, dynamic> data});
  Future<Either<Failure, bool>> rateDoctor(
      {required Map<String, dynamic> data});
}
