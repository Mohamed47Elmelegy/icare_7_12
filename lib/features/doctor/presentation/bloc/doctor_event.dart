import 'package:flutter/material.dart';
import 'package:icare/features/doctor/domain/entities/doctor_entity.dart';

@immutable
abstract class DoctorEvent {
  const DoctorEvent();
}

class FetchAllDoctorEvent extends DoctorEvent {
  final int page;
  const FetchAllDoctorEvent({this.page = 1});
}

class UpdateCurrentDoctorEvent extends DoctorEvent {
  final DoctorEntity doctor;
  const UpdateCurrentDoctorEvent({required this.doctor});
}

class RateDoctorEvent extends DoctorEvent {
  final Map<String, dynamic> data;
  const RateDoctorEvent({required this.data});
}

class UpdateRateDataEvent extends DoctorEvent {
  final double? rateValue;
  final String? rateTxt;
  const UpdateRateDataEvent({this.rateValue, this.rateTxt});
}

class ShowNearbyDoctorsEvent extends DoctorEvent {
  const ShowNearbyDoctorsEvent();
}

class ShowAllDoctorsEvent extends DoctorEvent {
  const ShowAllDoctorsEvent();
}

class SetDoctorOnMapEvent extends DoctorEvent {
  final BuildContext ctx;
  final bool showAllDoctors;
  final String? userType;
  final List<int>? serviceIds;
  const SetDoctorOnMapEvent({
    required this.ctx,
    this.showAllDoctors = false,
    this.userType,
    this.serviceIds,
  });
}

class UpdateSearchTxtEvent extends DoctorEvent {
  final String txt;
  const UpdateSearchTxtEvent({required this.txt});
}
