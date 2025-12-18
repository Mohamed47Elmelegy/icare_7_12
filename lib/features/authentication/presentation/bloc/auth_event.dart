import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/setting/data/models/specialty_model.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class LogInEvent extends AuthEvent {
  final Map<String, dynamic> user;
  const LogInEvent({required this.user});
}

class SocialLoginEvent extends AuthEvent {
  final Map<String, dynamic> user;
  const SocialLoginEvent({required this.user});
}

class RegisterEvent extends AuthEvent {
  final Map<String, dynamic> user;
  const RegisterEvent({required this.user});
}

class EnablePhoneRegisterButtonEvent extends AuthEvent {
  const EnablePhoneRegisterButtonEvent();
}

class ChangePasswordEvent extends AuthEvent {
  const ChangePasswordEvent();
}

class RememberMeEvent extends AuthEvent {
  const RememberMeEvent();
}

class SwitchGenderEvent extends AuthEvent {
  final bool man;
  const SwitchGenderEvent({required this.man});
}

class EnableAuthButtonEvent extends AuthEvent {
  final bool enable;
  const EnableAuthButtonEvent({required this.enable});
}

class UpdatePhoneCountryEvent extends AuthEvent {
  final String code;
  const UpdatePhoneCountryEvent({required this.code});
}

class UpdateCustomerTypeEvent extends AuthEvent {
  final String type;
  const UpdateCustomerTypeEvent({required this.type});
}

class SendVerifyEmailEvent extends AuthEvent {
  final String email;
  const SendVerifyEmailEvent({required this.email});
}

class LogOutEvent extends AuthEvent {
  const LogOutEvent();
}

class UpdateNurseRegisterDataEvent extends AuthEvent {
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
  const UpdateNurseRegisterDataEvent(
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
      this.languageList});
}

///nurse section
class SwitchNurseTypeEvent extends AuthEvent {
  final bool isNurse;
  final bool? isDoctor;
  const SwitchNurseTypeEvent({required this.isNurse, this.isDoctor});
}

class UpdateMarkersEvent extends AuthEvent {
  final Map<MarkerId, Marker>? markers;
  const UpdateMarkersEvent({required this.markers});
}

class UpdateSpecialtyEvent extends AuthEvent {
  final int? specialtyId;
  final SpecialtyModel? specialty;
  const UpdateSpecialtyEvent({required this.specialtyId, this.specialty});
}
