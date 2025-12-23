import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/account/data/data_sources/medical_reports_remote_data_source.dart';
import 'package:icare/features/account/domain/entities/medical_report_entity.dart';
import 'package:icare/features/account/domain/repositories/medical_reports_repository.dart';

class MedicalReportsRepositoryImpl implements MedicalReportsRepository {
  final MedicalReportsRemoteDataSource remoteDataSource;

  MedicalReportsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MedicalReportEntity>> createMedicalReport({
    required Map<String, dynamic> data,
    File? prescriptionImage,
  }) async {
    try {
      final result = await remoteDataSource.createMedicalReport(
        data: data,
        prescriptionImage: prescriptionImage,
      );
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<MedicalReportEntity>>> getPatientMedicalReports(
      String patientId) async {
    try {
      final result = await remoteDataSource.getPatientMedicalReports(patientId);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
