import 'package:icare/features/account/domain/entities/medical_report_entity.dart';

class MedicalReportModel extends MedicalReportEntity {
  const MedicalReportModel({
    super.id,
    super.patientId,
    super.createdBy,
    super.createdByName,
    super.createdByType,
    super.heartRate,
    super.bloodPressure,
    super.height,
    super.weight,
    super.pulseRate,
    super.description,
    super.prescriptionImage,
    super.createdAt,
    super.updatedAt,
  });

  factory MedicalReportModel.fromJson(Map<String, dynamic> json) {
    return MedicalReportModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      patientId: json['patient_id'] != null
          ? int.tryParse(json['patient_id'].toString())
          : null,
      createdBy: json['created_by'] != null && json['created_by'] is Map
          ? int.tryParse(json['created_by']['id'].toString())
          : (json['created_by'] != null
              ? int.tryParse(json['created_by'].toString())
              : null),
      createdByName: json['created_by'] != null && json['created_by'] is Map
          ? json['created_by']['name']?.toString()
          : json['created_by_name']?.toString(),
      createdByType: json['creator_type']?.toString() ??
          json['created_by_type']?.toString(),
      heartRate: json['heart_rate']?.toString(),
      bloodPressure: json['blood_pressure']?.toString(),
      height: json['height']?.toString(),
      weight: json['weight']?.toString(),
      pulseRate: json['pulse_rate']?.toString(),
      description: json['description']?.toString(),
      prescriptionImage: json['prescription_image_url']?.toString() ??
          json['prescription_image']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (createdBy != null) 'created_by': createdBy,
      if (createdByName != null) 'created_by_name': createdByName,
      if (createdByType != null) 'created_by_type': createdByType,
      if (heartRate != null) 'heart_rate': heartRate,
      if (bloodPressure != null) 'blood_pressure': bloodPressure,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (pulseRate != null) 'pulse_rate': pulseRate,
      if (description != null) 'description': description,
      if (prescriptionImage != null) 'prescription_image': prescriptionImage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }
}
