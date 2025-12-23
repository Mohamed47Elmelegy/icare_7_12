import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/account/domain/entities/medical_report_entity.dart';
import 'package:icare/features/account/domain/repositories/medical_reports_repository.dart';

class CreateMedicalReportUseCase {
  final MedicalReportsRepository repository;

  CreateMedicalReportUseCase({required this.repository});

  Future<Either<Failure, MedicalReportEntity>> call({
    required Map<String, dynamic> data,
    File? prescriptionImage,
  }) async {
    return await repository.createMedicalReport(
      data: data,
      prescriptionImage: prescriptionImage,
    );
  }
}
