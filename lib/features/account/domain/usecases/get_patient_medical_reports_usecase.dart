import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/account/domain/entities/medical_report_entity.dart';
import 'package:icare/features/account/domain/repositories/medical_reports_repository.dart';

class GetPatientMedicalReportsUseCase {
  final MedicalReportsRepository repository;

  GetPatientMedicalReportsUseCase({required this.repository});

  Future<Either<Failure, List<MedicalReportEntity>>> call(
      String patientId) async {
    return await repository.getPatientMedicalReports(patientId);
  }
}
