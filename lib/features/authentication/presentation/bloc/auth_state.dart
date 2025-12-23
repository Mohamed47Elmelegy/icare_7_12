import 'package:flutter/material.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthInitialState extends AuthState {}

class LogInSuccessfullyState extends AuthState {
  final AuthResponse response;
  const LogInSuccessfullyState({required this.response});
}

class LogInFailedState extends AuthState {
  final AuthResponse response;
  const LogInFailedState({required this.response});
}

class LogInLoadingState extends AuthState {
  const LogInLoadingState();
}

class LogOutLoadingState extends AuthState {
  const LogOutLoadingState();
}

class LogOutState extends AuthState {
  const LogOutState();
}

class RegisterSuccessfullyState extends AuthState {
  final AuthResponse response;
  const RegisterSuccessfullyState({required this.response});
}

// New state for pending registration (awaiting admin approval)
class RegistrationPendingState extends AuthState {
  final String message;
  const RegistrationPendingState({required this.message});
}

class RegisterFailedState extends AuthState {
  final AuthResponse response;
  const RegisterFailedState({required this.response});
}

class RegisterLoadingState extends AuthState {
  const RegisterLoadingState();
}

class SocialSuccessfullyState extends AuthState {
  final AuthResponse response;
  const SocialSuccessfullyState({required this.response});
  @override
  List<Object> get props => [response];
}

class SocialFailedState extends AuthState {
  final AuthResponse response;
  const SocialFailedState({required this.response});
}

class SocialLoadingState extends AuthState {
  const SocialLoadingState();
}

class EnableRegisterPhoneLoadingState extends AuthState {
  const EnableRegisterPhoneLoadingState();
}

class EnableRegisterPhoneSuccessState extends AuthState {
  const EnableRegisterPhoneSuccessState();
}

class ChangePasswordState extends AuthState {
  final bool showPass;
  const ChangePasswordState({required this.showPass});
}

class ConfirmEmailState extends AuthState {
  final AuthResponse response;
  const ConfirmEmailState({required this.response});
}

class EnableAuthButtonLoadingState extends AuthState {
  const EnableAuthButtonLoadingState();
}

class EnableAuthButtonState extends AuthState {
  const EnableAuthButtonState();
}

class UpdateGenerateUserLoadingState extends AuthState {
  const UpdateGenerateUserLoadingState();
}

class UpdateGenerateUserFailedState extends AuthState {
  const UpdateGenerateUserFailedState();
}

class UpdateGenerateUserSuccessfullyState extends AuthState {
  const UpdateGenerateUserSuccessfullyState();
}

class GenerateUserLoadingState extends AuthState {
  const GenerateUserLoadingState();
}

class GenerateUserFailedState extends AuthState {
  const GenerateUserFailedState();
}

class GenerateUserSuccessfullyState extends AuthState {
  const GenerateUserSuccessfullyState();
}

class UpdateCustomerTypeLoadingState extends AuthState {
  const UpdateCustomerTypeLoadingState();
}

class UpdateCustomerTypeSuccessfullyState extends AuthState {
  const UpdateCustomerTypeSuccessfullyState();
}
