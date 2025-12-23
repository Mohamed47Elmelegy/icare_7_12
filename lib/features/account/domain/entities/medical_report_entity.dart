import 'package:equatable/equatable.dart';

class MedicalReportEntity extends Equatable {
  final int? id;
  final int? patientId;
  final int? createdBy;
  final String? createdByName;
  final String? createdByType; // 'doctor', 'nurse', 'assistant'
  final String? heartRate;
  final String? bloodPressure;
  final String? height;
  final String? weight;
  final String? pulseRate;
  final String? description;
  final String? prescriptionImage;
  final String? createdAt;
  final String? updatedAt;

  const MedicalReportEntity({
    this.id,
    this.patientId,
    this.createdBy,
    this.createdByName,
    this.createdByType,
    this.heartRate,
    this.bloodPressure,
    this.height,
    this.weight,
    this.pulseRate,
    this.description,
    this.prescriptionImage,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        patientId,
        createdBy,
        createdByName,
        createdByType,
        heartRate,
        bloodPressure,
        height,
        weight,
        pulseRate,
        description,
        prescriptionImage,
        createdAt,
        updatedAt,
      ];
}
