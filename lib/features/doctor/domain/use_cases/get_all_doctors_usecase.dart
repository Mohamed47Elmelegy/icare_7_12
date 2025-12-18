import 'package:icare/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:icare/features/doctor/domain/entities/doctor_entity.dart';
import 'package:icare/features/doctor/domain/repositories/doctor_repository.dart';

class GetAllDoctorsUseCase {
  final DoctorsRepository doctorRepository;

  GetAllDoctorsUseCase({required this.doctorRepository});

  Future<Either<Failure, List<DoctorEntity>>> call(
      {required Map<String, dynamic> data}) async {
    return await doctorRepository.getAllDoctors(data: data);
  }
}

class RateDoctorUseCase {
  final DoctorsRepository doctorRepository;

  RateDoctorUseCase({required this.doctorRepository});

  Future<Either<Failure, bool>> call(
      {required Map<String, dynamic> data}) async {
    return await doctorRepository.rateDoctor(data: data);
  }
}
