import 'package:flutter/material.dart';

@immutable
abstract class DoctorState {
  const DoctorState();
}

class DoctorInitialState extends DoctorState {}

class FetchAllDoctorsSuccessfullyState extends DoctorState {}

class FetchAllDoctorsLoadingState extends DoctorState {}

class FetchAllDoctorsFailedState extends DoctorState {}

class RateDataLoadingState extends DoctorState {}

class UpdateRateDataState extends DoctorState {}

class AddDoctorRateSuccessfullyState extends DoctorState {}
