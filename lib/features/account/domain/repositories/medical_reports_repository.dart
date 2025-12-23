import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/account/domain/entities/medical_report_entity.dart';

abstract class MedicalReportsRepository {
  Future<Either<Failure, MedicalReportEntity>> createMedicalReport({
    required Map<String, dynamic> data,
    File? prescriptionImage,
  });

  Future<Either<Failure, List<MedicalReportEntity>>> getPatientMedicalReports(
      String patientId);
}
