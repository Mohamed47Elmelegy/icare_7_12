import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/domain/use_cases/social_login_user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/constants/constant.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';
import 'package:icare/features/authentication/domain/use_cases/login_user_usecase.dart';
import 'package:icare/features/authentication/domain/use_cases/register_user_usecase.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_event.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';

import 'package:icare/core/coordinator/app_startup_coordinator.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  bool showPassword = false;
  String resMsg = "";
  static AuthBloc get(BuildContext context) => BlocProvider.of(context);

  final LoginUserServiceUseCase loginUserServiceUseCase;
  final RegisterUserServiceUseCase registerUserServiceUseCase;
  final SocialUserServiceUseCase socialUserServiceUseCase;
  final AppStartupCoordinator appStartupCoordinator;

  AuthBloc({
    required this.loginUserServiceUseCase,
    required this.registerUserServiceUseCase,
    required this.socialUserServiceUseCase,
    required this.appStartupCoordinator,
  }) : super(AuthInitialState()) {
    on<RegisterEvent>((RegisterEvent event, emit) async {
      await register(emit, event);
    });

    on<LogInEvent>((event, emit) async {
      await logIn(event, emit);
    });

    on<UpdateCustomerTypeEvent>((event, emit) {
      updateCustomerType(event, emit);
    });

    on<LogOutEvent>((event, emit) async {
      await logOut(event, emit);
    });

    on<ChangePasswordEvent>((event, emit) {
      changePasswordEvent(emit);
    });

    on<EnableAuthButtonEvent>((event, emit) {
      enableAuthButton(event, emit);
    });

    on<SendVerifyEmailEvent>((event, emit) async {
      // await sendVerifyEmail(event,emit);
    });

    on<RememberMeEvent>((event, emit) {
      rememberMeFn(event, emit);
    });

    on<EnablePhoneRegisterButtonEvent>((event, emit) {
      enableRegisterByPhone(event, emit);
    });

    on<SwitchGenderEvent>((event, emit) {
      switchGender(event, emit);
    });

    on<UpdatePhoneCountryEvent>((event, emit) {
      updatePhoneCountry(event, emit);
    });

    on<SocialLoginEvent>((event, emit) async {
      await socialLogin(event, emit);
    });

    on<SwitchNurseTypeEvent>((event, emit) async {
      switchNurseType(event, emit);
    });
  }

  String currentCode = "";
  String? name;
  String? email;
  String? phone;
  String? password;
  String? countryCode;

  updatePhoneCountry(UpdatePhoneCountryEvent event, emit) {
    emit(const UpdateCustomerTypeLoadingState());
    currentCode = event.code;
    countryCode = event.code;
    emit(const UpdateCustomerTypeSuccessfullyState());
  }

  String? customerType;
  updateCustomerType(UpdateCustomerTypeEvent event, emit) {
    emit(const UpdateCustomerTypeSuccessfullyState());
    customerType = event.type;
    emit(const UpdateCustomerTypeLoadingState());
  }

  bool isWomen = false;
  switchGender(SwitchGenderEvent event, emit) {
    emit(const EnableAuthButtonLoadingState());
    isWomen = !event.man;
    emit(const EnableAuthButtonState());
  }

  bool rememberMe = false;
  rememberMeFn(event, emit) {
    emit(const EnableAuthButtonLoadingState());
    rememberMe = !rememberMe;
    emit(const EnableAuthButtonState());
  }

  enableAuthButton(event, emit) {
    emit(const EnableAuthButtonLoadingState());
    // enableButton = event.enable;
    emit(const EnableAuthButtonState());
  }

  /// register section
  bool registerByPhone = false;
  enableRegisterByPhone(event, emit) {
    emit(const EnableRegisterPhoneLoadingState());
    registerByPhone = !registerByPhone;
    emit(const EnableRegisterPhoneSuccessState());
  }

  register(emit, RegisterEvent event) async {
    emit(const RegisterLoadingState());

    // ✅ تحقق من user_type قبل التسجيل
    String userType = event.user['user_type'] ?? 'customer';
    // Registering user


    try {
      var res = await registerUserServiceUseCase(userData: event.user);
      if (emit.isDone) return;

      res.fold((l) {
        resMsg = l.toString();
        emit(RegisterFailedState(
            response: AuthResponse(msg: resMsg, isFailed: true)));
      }, (data) {
        resMsg = data.msg.toString();
        if (data.isSuccess == true) {
          // ✅ تحقق من نوع المستخدم
          if (userType == 'nurse' ||
              userType == 'doctor' ||
              userType == 'assistant') {
            // Nurse/Doctor needs admin approval
            emit(RegistrationPendingState(
                message: translate("auth.pending_approval_message")));
          } else {
            // Customer can login directly
            emit(RegisterSuccessfullyState(
                response: AuthResponse(msg: resMsg, isSuccess: true)));
          }
        } else {
          emit(RegisterFailedState(
              response: AuthResponse(msg: resMsg, isFailed: true)));
        }
      });
    } catch (e) {

      if (!emit.isDone) {
        emit(RegisterFailedState(
            response: AuthResponse(msg: resMsg, isFailed: true)));
      }
    }
  }

  logIn(LogInEvent event, emit) async {
    emit(const LogInLoadingState());
    try {
      var res = await loginUserServiceUseCase(data: event.user);
      if (emit.isDone) return;

      await res.fold((l) {
        resMsg = l.toString();
        emit(LogInFailedState(
            response: AuthResponse(msg: resMsg, isFailed: true)));
      }, (data) async {
        resMsg = data.msg.toString();
        if (data.user == null) {
          emit(LogInFailedState(
              response: AuthResponse(msg: resMsg, isFailed: true)));
        } else {
          // Clean Architecture: Initialize app data before finalizing login state
          emit(const AuthInitializingState());

          final isInitSuccess = await appStartupCoordinator.initApp();

          if (isInitSuccess) {
            emit(LogInSuccessfullyState(
                response: AuthResponse(msg: resMsg, isSuccess: true)));
          } else {
            // Initialization failed (e.g., account pending approval)
            // resMsg should be set by coordinator if needed, otherwise fallback
            resMsg = translate("toast.account_not_approved");
            emit(LogInFailedState(
                response: AuthResponse(msg: resMsg, isFailed: true)));
          }
        }
      });
    } catch (e) {

      if (!emit.isDone) {
        emit(LogInFailedState(
            response: AuthResponse(msg: resMsg, isFailed: true)));
      }
    }
  }

  socialLogin(SocialLoginEvent event, emit) async {
    emit(const SocialLoadingState());
    try {
      var res = await socialUserServiceUseCase(data: event.user);
      if (emit.isDone) return;

      await res.fold((l) {
        resMsg = l.toString();
        emit(SocialFailedState(
            response: AuthResponse(msg: resMsg, isFailed: true)));
      }, (data) async {
        resMsg = data.msg.toString();
        if (data.user == null) {
          emit(SocialFailedState(
              response: AuthResponse(msg: resMsg, isFailed: true)));
        } else {
          // Initialize app data before finalizing login state
          emit(const AuthInitializingState());

          final isInitSuccess = await appStartupCoordinator.initApp();

          if (isInitSuccess) {
            emit(SocialSuccessfullyState(
                response: AuthResponse(msg: resMsg, isSuccess: true)));
          } else {
            resMsg = translate("toast.account_not_approved");
            emit(SocialFailedState(
                response: AuthResponse(msg: resMsg, isFailed: true)));
          }
        }
      });
    } catch (e) {

      if (!emit.isDone) {
        emit(SocialFailedState(
            response: AuthResponse(msg: resMsg, isFailed: true)));
      }
    }
  }

  logOut(event, emit) async {
    emit(const LogOutLoadingState());
    String lang = Util.getLang();
    String type = Util.getUserType();
    await SharedPref().clearPreferences();
    if (emit.isDone) return;
    await SharedPref().setPreferencesString(Constants.userLang, lang);
    await SharedPref().setPreferencesString(Constants.userType, type);
    emit(const LogOutState());
  }

  changePasswordEvent(emit) {
    showPassword = !showPassword;
    emit(ChangePasswordState(showPass: showPassword));
  }

  sendVerifyEmail(event, emit) async {}

  saveUserDate(AuthResponse res) async {
    if (res.user == null) return;
    await SharedPref.preferences
        .setPreferencesString(Constants.userId, res.user!.userId.toString());
    await SharedPref.preferences.setPreferencesString(
        Constants.userLogin, res.user!.userLogin.toString());
    await SharedPref.preferences
        .setPreferencesString(Constants.email, res.user!.email.toString());
    await SharedPref.preferences
        .setPreferencesString(Constants.name, res.user!.userName.toString());
    await SharedPref.preferences.setPreferencesString(
        Constants.mobile, res.user!.phoneNumber.toString());
    await SharedPref.preferences
        .setPreferencesString(Constants.city, res.user!.countryCode.toString());
    await SharedPref.preferences
        .setPreferencesString(Constants.address, res.user!.address.toString());
  }

  /// nurse section
  bool isNurse = false;
  bool isDoctor = false;
  switchNurseType(SwitchNurseTypeEvent event, emit) {
    emit(const EnableAuthButtonLoadingState());
    isNurse = event.isNurse;
    isDoctor = event.isDoctor ?? false;
    emit(const EnableAuthButtonState());
  }
}
