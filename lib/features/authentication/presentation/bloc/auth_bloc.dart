import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/domain/use_cases/social_login_user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/constant.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/features/authentication/data/models/auth_response.dart';
import 'package:icare/features/authentication/domain/use_cases/login_user_usecase.dart';
import 'package:icare/features/authentication/domain/use_cases/register_user_usecase.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_event.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  bool showPassword = false;
  String resMsg = "";
  static AuthBloc get(BuildContext context) => BlocProvider.of(context);

  LoginUserServiceUseCase loginUserServiceUseCase;
  RegisterUserServiceUseCase registerUserServiceUseCase;
  SocialUserServiceUseCase socialUserServiceUseCase;
  AuthBloc({
    required this.loginUserServiceUseCase,
    required this.registerUserServiceUseCase,
    required this.socialUserServiceUseCase,
  }) : super(AuthInitialState()) {
    on<RegisterEvent>((RegisterEvent event, emit) async {
      await register(emit, event);
    });
    on<UpdateNurseRegisterDataEvent>((event, emit) {
      updateNurseRegisterData(event, emit);
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

    on<SwitchNurseTypeEvent>((event, emit) {
      switchNurseType(event, emit);
    });

    on<UpdateMarkersEvent>((event, emit) {
      updateMarkers(event, emit);
    });
  }

  String currentCode = "";
  updatePhoneCountry(UpdatePhoneCountryEvent event, emit) {
    emit(const UpdateCustomerTypeLoadingState());
    currentCode = event.code;
    emit(const UpdateCustomerTypeSuccessfullyState());
  }

  File? license;
  File? certificate;
  File? nurseID;
  File? associationCard;
  File? relatedJobId;
  File? avatar;
  NurseEntity? nurse;
  List<String>? languageList;
  List<String>? educationList;
  List<String>? publicationsList;
  List<String>? coursesList;
  updateNurseRegisterData(UpdateNurseRegisterDataEvent event, emit) {
    emit(const UpdateCustomerTypeLoadingState());
    if (event.nurse != null) nurse = event.nurse;
    if (event.license != null) license = event.license;
    if (event.certificate != null) certificate = event.certificate;
    if (event.nurseID != null) nurseID = event.nurseID;
    if (event.associationCard != null) associationCard = event.associationCard;
    if (event.relatedJobId != null) relatedJobId = event.relatedJobId;
    if (event.avatar != null) avatar = event.avatar;
    if (event.languageList != null) languageList = event.languageList;
    if (event.educationList != null) educationList = event.educationList;
    if (event.publicationsList != null)
      publicationsList = event.publicationsList;
    if (event.coursesList != null) coursesList = event.coursesList;
    emit(const UpdateCustomerTypeSuccessfullyState());
  }

  checkNurseRegisterInfoCompleted() {
    if (nurse != null &&
        languageList != null &&
        languageList!.isNotEmpty &&
        educationList != null &&
        educationList!.isNotEmpty &&
        publicationsList != null &&
        publicationsList!.isNotEmpty &&
        coursesList != null &&
        coursesList!.isNotEmpty) return true;
    return false;
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
    try {
      var res = await registerUserServiceUseCase(userData: event.user);
      res.fold((l) {
        resMsg = l.toString();
        emit(RegisterFailedState(
            response: AuthResponse(msg: resMsg, isFailed: true)));
      }, (data) {
        resMsg = data.msg.toString();
        if (data.isSuccess == true) {
          // Don't auto-login, instead emit pending state
          // User needs admin approval before accessing the app
          emit(RegistrationPendingState(
              message: translate("auth.pending_approval_message")));
        } else {
          emit(RegisterFailedState(
              response: AuthResponse(msg: resMsg, isFailed: true)));
        }
      });
    } catch (e) {
      debugPrint("registerError: $e");
      emit(RegisterFailedState(
          response: AuthResponse(msg: resMsg, isFailed: true)));
    }
  }

  logIn(LogInEvent event, emit) async {
    emit(const LogInLoadingState());
    try {
      var res = await loginUserServiceUseCase(data: event.user);
      res.fold((l) {
        resMsg = l.toString();
      }, (data) {
        resMsg = data.msg.toString();
        if (data.user == null) {
          emit(LogInFailedState(
              response: AuthResponse(msg: resMsg, isFailed: true)));
        } else {
          emit(LogInSuccessfullyState(
              response: AuthResponse(msg: resMsg, isSuccess: true)));
        }
      });
    } catch (e) {
      debugPrint("logInError: $e");
      emit(LogInFailedState(
          response: AuthResponse(msg: resMsg, isFailed: true)));
    }
  }

  socialLogin(SocialLoginEvent event, emit) async {
    emit(const SocialLoadingState());
    try {
      var res = await socialUserServiceUseCase(data: event.user);
      res.fold((l) {
        resMsg = l.toString();
      }, (data) {
        resMsg = data.msg.toString();
        if (data.user == null) {
          emit(SocialFailedState(
              response: AuthResponse(msg: resMsg, isFailed: true)));
        } else {
          emit(SocialSuccessfullyState(
              response: AuthResponse(msg: resMsg, isSuccess: true)));
        }
      });
    } catch (e) {
      debugPrint("socialLogin: $e");
      emit(SocialFailedState(
          response: AuthResponse(msg: resMsg, isFailed: true)));
    }
  }

  logOut(event, emit) async {
    emit(const LogOutLoadingState());
    String lang = Util.getLang();
    String type = Util.getUserType();
    await SharedPref().clearPreferences();
    await SharedPref().setPreferencesString(Constants.userLang, lang);
    await SharedPref().setPreferencesString(Constants.userType, type);
    emit(const LogOutState());
  }

  changePasswordEvent(emit) {
    showPassword = !showPassword;
    emit(ChangePasswordState(showPass: showPassword));
  }

  sendVerifyEmail(event, emit) async {
    // var code = DateTime.now().millisecond.toString().substring(0,2).toString() + DateTime.now().minute.toString().substring(0,1)+DateTime.now().second.toString().substring(0,1)+DateTime.now().millisecondsSinceEpoch.toString().substring(0,2).toString();
    // SharedPref.preferences.setPreferencesString(Constants.lastVerificationCode,code);
    // await SendGmail.sendEmailMessage("Verification Code: $code", event.email.toString(), "icarestars Medical - Verification Code");
    // emit(ConfirmEmailState(response: AuthResponse(state: states = FetchStates.SUCCESSFULLY,msg: translate("toast.successfully_send"))));
  }

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
  bool isNurse = true;
  switchNurseType(SwitchNurseTypeEvent event, emit) {
    emit(const EnableAuthButtonLoadingState());
    isNurse = event.isNurse;
    emit(const EnableAuthButtonState());
  }

  //google map
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  updateMarkers(UpdateMarkersEvent event, emit) {
    emit(AuthInitialState());
    markers.addAll(event.markers!);
    print('markers : ${markers.length}');
    emit(const EnableAuthButtonState());
  }
}
