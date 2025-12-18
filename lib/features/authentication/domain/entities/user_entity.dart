import 'package:equatable/equatable.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/categories/data/models/allergies.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/doctor/domain/entities/doctor_entity.dart';

class UserService extends Equatable {
  final int? userId;
  final String? userLogin;
  final String? userName;
  final String? phoneNumber;
  final String? email;
  final String? image;
  final String? area;
  final String? address;
  final String? countryCode;
  final String? cityID;
  final String? governorate;
  final double? lat;
  final double? long;
  final bool? status;
  final String? userType;
  final bool? isWomen;

  final String? lastNotificationUnread;

  /// if false then user is offline
  final bool? isApproved;

  final List<AllergiesModel>? allergiesList;
  final String? publications;
  final String? medicalConditions;

  final NurseEntity? nurse;
  final DoctorEntity? doctor;
  final List<String>? emergencyContactsList;

  final double? distanceKM;
  final double? distanceM;

  const UserService(
      {this.userId,
      this.userLogin,
      this.userName,
      this.phoneNumber,
      this.email,
      this.image,
      this.area,
      this.cityID,
      this.governorate,
      this.address,
      this.countryCode,
      this.status,
      this.isApproved,
      this.lat,
      this.long,
      this.lastNotificationUnread,
      this.userType,
      this.isWomen,
      this.allergiesList,
      this.publications,
      this.medicalConditions,
      this.nurse,
      this.doctor,
      this.emergencyContactsList,
      this.distanceKM,
      this.distanceM});

  @override
  List<Object?> get props =>
      [userId, userName, email, area, address, countryCode];

  String viewTypeText() {
    final type = userType.toString().toLowerCase();
    if (type == "nurse") {
      return "${translate("nurse.nurse")} ".replaceAll("null", "");
    }
    if (type == "assistant") {
      return "${translate("nurse.assistant")} ".replaceAll("null", "");
    }
    if (type == "doctor") {
      return "${translate("doctor.doctor")} ".replaceAll("null", "");
    }
    return "";
  }
}
