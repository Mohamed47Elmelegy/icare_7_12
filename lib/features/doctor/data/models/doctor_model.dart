import 'dart:convert';
import 'package:icare/core/strings/api/api_url.dart';
import 'package:icare/features/authentication/data/models/user_service_model.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/categories/domain/entities/categories_entity.dart';
import 'package:icare/features/nurse/data/models/review_model.dart';
import 'package:icare/features/doctor/domain/entities/doctor_entity.dart';

class DoctorModel extends DoctorEntity {
  const DoctorModel({
    required super.id,
    super.userData,
    required super.doctorId,
    required super.associationCard,
    required super.licence,
    required super.certificate,
    required super.reviewList,
    required super.languageList,
    required super.educationList,
    required super.publicationsList,
    required super.coursesList,
    required super.servicesList,
    super.distanceKM,
    super.distanceM,
  });

  /// Helper function to parse list fields that can be either JSON array or comma-separated string
  static List<String> _parseListField(dynamic field) {
    if (field == null || field.toString().isEmpty || field.toString() == 'null') {
      return [];
    }
    
    try {
      // Try to parse as JSON array first
      final decoded = jsonDecode(field.toString());
      if (decoded is List) {
        return decoded.cast<String>().toList();
      }
      return [];
    } catch (e) {
      // If JSON parsing fails, treat it as comma-separated string
      return field
          .toString()
          .split('،') // Arabic comma
          .map((s) => s.split(',')) // English comma
          .expand((s) => s) // Flatten
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
  }

  static DoctorModel fromJson(Map<String, dynamic> json) {
    List<ServicesModel> list = json['services'] == null || json['services'].toString() == ""
        ? []
        : ServicesModel.listModelFromJson(json['services']);
    var doctor = DoctorModel(
      id: json['id'],
      userData: json['user'] == null ? null : UserServiceModel.fromJson(json['user']),
      doctorId: "${ApiUrl.STORAGE_URL}${json['identification_card']}",
      associationCard: "${ApiUrl.STORAGE_URL}${json['association_card']}",
      licence: "${ApiUrl.STORAGE_URL}${json['license_practice']}",
      certificate: "${ApiUrl.STORAGE_URL}${json['graduation_certificate']}",
      reviewList: ReviewModel.listModelFromJson(jsonEncode(json['reviews'])),
      languageList: json['languages'] == null || json['languages'] == '' || json['languages'].toString() == 'null'
          ? []
          : _parseListField(json['languages']),
      educationList: json['education'] == null || json['education'] == '' || json['education'].toString() == 'null'
          ? []
          : _parseListField(json['education']),
      publicationsList:
          json['publications'] == null || json['publications'] == '' || json['publications'].toString() == 'null'
              ? []
              : _parseListField(json['publications']),
      coursesList: json['courses'] == null || json['courses'] == '' || json['courses'].toString() == 'null'
          ? []
          : _parseListField(json['courses']),
      servicesList: list,
      distanceKM: double.tryParse(json['distanceKm'] ?? "-1"),
      distanceM: double.tryParse(json['distanceMe'] ?? "-1"),
    );
    return doctor;
  }

  static DoctorModel fromJsonUser(Map<String, dynamic> json) {
    List<ServicesModel> list = json['services'] == null || json['services'].toString() == ""
        ? []
        : ServicesModel.listModelFromJson(json['services']);
    return DoctorModel(
      id: json['id'],
      doctorId: "${ApiUrl.STORAGE_URL}${json['identification_card']}",
      associationCard: "${ApiUrl.STORAGE_URL}${json['association_card']}",
      licence: "${ApiUrl.STORAGE_URL}${json['license_practice']}",
      certificate: "${ApiUrl.STORAGE_URL}${json['graduation_certificate']}",
      reviewList: ReviewModel.listModelFromJson(jsonEncode(json['reviews'])),
      languageList: json['languages'] == null || json['languages'] == '' ? [] : _parseListField(json['languages']),
      educationList: json['education'] == null || json['education'] == '' ? [] : _parseListField(json['education']),
      publicationsList: json['publications'] == null || json['publications'] == '' ? [] : _parseListField(json['publications']),
      coursesList: json['courses'] == null || json['courses'] == '' ? [] : _parseListField(json['courses']),
      servicesList: list,
      distanceKM: double.tryParse(json['distanceKm'] ?? "-1"),
      distanceM: double.tryParse(json['distanceMe'] ?? "-1"),
    );
  }

  static Map<String, dynamic> toJsonLocal(CategoriesEntity item) {
    return {
      "id": int.tryParse(item.id.toString()),
    };
  }

  static List<DoctorModel> listModelFromJson(String str) =>
      List<DoctorModel>.from(json.decode(str).map((x) => DoctorModel.fromJson(x)));
}
