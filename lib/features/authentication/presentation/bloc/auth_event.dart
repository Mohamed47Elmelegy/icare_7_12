import 'package:flutter/material.dart';

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

/// nurse section
class SwitchNurseTypeEvent extends AuthEvent {
  final bool isNurse;
  final bool? isDoctor;
  const SwitchNurseTypeEvent({required this.isNurse, this.isDoctor});
}
