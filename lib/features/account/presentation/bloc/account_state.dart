import 'package:flutter/material.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';

@immutable
abstract class AccountState {
  const AccountState();
}

class AccountInitialState extends AccountState {}

class UpdateProfileState extends AccountState {
  final AuthResponse response;
  const UpdateProfileState({required this.response});
}

class ChangeUserPasswordState extends AccountState {
  final AuthResponse response;
  const ChangeUserPasswordState({required this.response});
}

class FetchProfileDataState extends AccountState {
  final AuthResponse response;
  const FetchProfileDataState({required this.response});
}

class FetchNotificationsSuccessfullyState extends AccountState {
  const FetchNotificationsSuccessfullyState();
}

class FetchNotificationsLoadingState extends AccountState {
  const FetchNotificationsLoadingState();
}

class FetchNotificationsFailedState extends AccountState {
  const FetchNotificationsFailedState();
}

class UpdateNotificationsModeState extends AccountState {
  const UpdateNotificationsModeState();
}

class ProfileLoadingState extends AccountState {
  const ProfileLoadingState();
}

class ProfileFailedState extends AccountState {
  const ProfileFailedState();
}

class ProfileSuccessState extends AccountState {
  const ProfileSuccessState();
}

class UpdateNurseDataSuccessState extends AccountState {
  const UpdateNurseDataSuccessState();
}

class UpdateDoctorDataSuccessState extends AccountState {
  const UpdateDoctorDataSuccessState();
}
