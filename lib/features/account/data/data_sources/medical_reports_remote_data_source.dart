import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icare/core/error/exception.dart';
import 'package:icare/core/strings/api/api_url.dart';
import 'package:icare/features/account/data/models/medical_report_model.dart';

abstract class MedicalReportsRemoteDataSource {
  Future<MedicalReportModel> createMedicalReport({
    required Map<String, dynamic> data,
    File? prescriptionImage,
  });

  Future<List<MedicalReportModel>> getPatientMedicalReports(String patientId);
}

class MedicalReportsRemoteDataSourceImpl
    implements MedicalReportsRemoteDataSource {
  final http.Client client;

  MedicalReportsRemoteDataSourceImpl({required this.client});

  @override
  Future<MedicalReportModel> createMedicalReport({
    required Map<String, dynamic> data,
    File? prescriptionImage,
  }) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(ApiUrl.MEDICAL_REPORTS));

      // Add headers
      var headers = ApiUrl.headerAuth;
      request.headers.addAll(headers);

      // Add required fields
      if (data['patient_id'] != null) {
        request.fields['patient_id'] = data['patient_id'].toString();
      }
      if (data['heartRate'] != null) {
        request.fields['heartRate'] = data['heartRate'].toString();
      }
      if (data['bloodPressure'] != null) {
        request.fields['bloodPressure'] = data['bloodPressure'].toString();
      }
      if (data['height'] != null) {
        request.fields['height'] = data['height'].toString();
      }
      if (data['weight'] != null) {
        request.fields['weight'] = data['weight'].toString();
      }
      if (data['pulseRate'] != null) {
        request.fields['pulseRate'] = data['pulseRate'].toString();
      }
      if (data['description'] != null) {
        request.fields['description'] = data['description'].toString();
      }
      if (data['created_by'] != null) {
        request.fields['created_by'] = data['created_by'].toString();
        // Critical: Override ID header to ensure backend treats this as nurse/doctor action
        // even if local context is switched to patient
        request.headers['ID'] = data['created_by'].toString();
      }

      // Add prescription image if provided
      if (prescriptionImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'prescriptionImage',
          prescriptionImage.path,
        ));
      }

      debugPrint("📤 Creating Medical Report: ${request.fields}");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint("📥 Create Medical Report Response: ${response.body}");

      final decodedData = json.decode(response.body);

      if (decodedData['status'] == true) {
        return MedicalReportModel.fromJson(decodedData['data']);
      } else {
        debugPrint("❌ API Error: ${decodedData['message']}");
        throw ServerException();
      }
    } catch (e) {
      debugPrint("❌ Create Medical Report Error: $e");
      throw ServerException();
    }
  }

  @override
  Future<List<MedicalReportModel>> getPatientMedicalReports(
      String patientId) async {
    try {
      final response = await client.get(
        Uri.parse(
            "${ApiUrl.PATIENT_MEDICAL_REPORTS}/$patientId/medical-reports"),
        headers: ApiUrl.headerAuth,
      );

      debugPrint("📥 Get Patient Medical Reports Response: ${response.body}");

      final decodedData = json.decode(response.body);

      if (decodedData['status'] == true) {
        List<MedicalReportModel> reports = [];

        if (decodedData['medical_reports'] != null &&
            decodedData['medical_reports'] is List) {
          reports = (decodedData['medical_reports'] as List)
              .map((report) => MedicalReportModel.fromJson(report))
              .toList();
        }

        return reports;
      } else {
        throw ServerException();
      }
    } catch (e) {
      debugPrint("❌ Get Patient Medical Reports Error: $e");
      throw ServerException();
    }
  }
}
