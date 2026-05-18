import 'dart:io';

import 'package:flutter/material.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/doctor/domain/entities/doctor_entity.dart';
import 'package:icare/features/setting/domain/entities/specialty_entity.dart';

@immutable
abstract class AccountEvent {
  const AccountEvent();
}

class EnableUpdateProfileEvent extends AccountEvent {
  final bool? isImg;
  final bool? isSave;
  const EnableUpdateProfileEvent({this.isImg, this.isSave});
}

class UpdateProfileCurrentDataEvent extends AccountEvent {
  final Map<String, dynamic> userData;
  const UpdateProfileCurrentDataEvent({required this.userData});
}

class UpdateProfileEvent extends AccountEvent {
  final Map<String, dynamic> user;
  const UpdateProfileEvent({required this.user});
}

class FetchProfileDataEvent extends AccountEvent {
  final bool isSilent;
  final String? userId;
  const FetchProfileDataEvent({this.isSilent = false, this.userId});
}

class FetchAllUsersDataEvent extends AccountEvent {
  const FetchAllUsersDataEvent();
}

class ChangeUserPasswordEvent extends AccountEvent {
  final Map<String, dynamic> data;
  const ChangeUserPasswordEvent({required this.data});
}

class ChangeNotificationModeEvent extends AccountEvent {
  const ChangeNotificationModeEvent();
}

class SwitchProfileTapsEvent extends AccountEvent {
  final int index;
  const SwitchProfileTapsEvent({required this.index});
}

class UpdateUserPatientDataEvent extends AccountEvent {
  final Map<String, dynamic> data;
  const UpdateUserPatientDataEvent({required this.data});
}

///nurse section
class SwitchProfileStatusEvent extends AccountEvent {
  final bool? isOnline;
  const SwitchProfileStatusEvent({this.isOnline});
}

class UpdateNurseDataEvent extends AccountEvent {
  final NurseEntity? nurse;
  final File? license;
  final File? certificate;
  final File? nurseID;
  final File? associationCard;
  final File? relatedJobId;
  final File? avatar;
  final List<String>? educationList;
  final List<String>? publicationsList;
  final List<String>? coursesList;
  final List<String>? languageList;
  final List<String>? emergencyContactsList;
  final List<ServicesModel>? servicesList;
  const UpdateNurseDataEvent(
      {this.nurse,
      this.license,
      this.certificate,
      this.nurseID,
      this.associationCard,
      this.relatedJobId,
      this.avatar,
      this.educationList,
      this.coursesList,
      this.publicationsList,
      this.languageList,
      this.servicesList,
      this.emergencyContactsList});
}

class UpdateDoctorDataEvent extends AccountEvent {
  final DoctorEntity? doctor;
  final File? license;
  final File? certificate;
  final File? doctorID;
  final File? associationCard;
  final File? relatedJobId;
  final File? avatar;
  final List<String>? educationList;
  final List<String>? publicationsList;
  final List<String>? coursesList;
  final List<String>? languageList;
  final List<String>? emergencyContactsList;
  final SpecialtyEntity? selectedSpecialty; // ✅ CHANGED: was servicesList
  const UpdateDoctorDataEvent(
      {this.doctor,
      this.license,
      this.certificate,
      this.doctorID,
      this.associationCard,
      this.relatedJobId,
      this.avatar,
      this.educationList,
      this.coursesList,
      this.publicationsList,
      this.languageList,
      this.selectedSpecialty, // ✅ CHANGED
      this.emergencyContactsList});
}

/// Medical Reports Section
class CreateMedicalReportEvent extends AccountEvent {
  final Map<String, dynamic> data;
  final File? prescriptionImage;
  const CreateMedicalReportEvent({
    required this.data,
    this.prescriptionImage,
  });
}

class FetchPatientMedicalReportsEvent extends AccountEvent {
  final String patientId;
  const FetchPatientMedicalReportsEvent({required this.patientId});
}

class DeleteAccountEvent extends AccountEvent {
  final String userId;
  const DeleteAccountEvent({required this.userId});
}

class ModifyCurrentService extends AccountEvent {
  final ServicesModel item;
  final bool? isRemove;
  const ModifyCurrentService({required this.item, this.isRemove});
}

class EnableModifyCurrentService extends AccountEvent {
  final int item;
  const EnableModifyCurrentService({required this.item});
}
