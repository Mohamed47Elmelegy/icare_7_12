// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:icare/core/strings/enum/user_enum.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/sms_api.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_event.dart';
import 'package:icare/features/authentication/presentation/screens/reset_password.dart';
import 'package:icare/features/authentication/presentation/screens/login.dart';
import 'package:icare/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/constant.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';
import 'package:icare/features/root_app/screens/welcome_screens/new_experience_screen.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isRegister;
  final bool? isLogin;
  final bool? isChangePhone;
  const PinCodeVerificationScreen(
      {super.key,
      required this.data,
      this.isRegister = false,
      this.isLogin = false,
      this.isChangePhone});

  @override
  State<PinCodeVerificationScreen> createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  var onTapRecognizer = TapGestureRecognizer();
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  late AuthBloc authBloc;
  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool sendVerify = true;
  late LocationsBloc locationsBloc;
  Map<String, dynamic> registerData = {};

  @override
  void initState() {
    locationsBloc = LocationsBloc.get(context);
    authBloc = AuthBloc.get(context);
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    textEditingController.text = "2025";

    /// if register mode will add extra data
    if (widget.isRegister) {
      registerData = widget.data;
      registerData['city'] = locationsBloc.city;
      registerData['governorate'] = locationsBloc.governorate;
      if (locationsBloc.currentCheckOutLocation != null) {
        registerData['latitude'] = locationsBloc.currentCheckOutLocation!.lat;
        registerData['longitude'] = locationsBloc.currentCheckOutLocation!.long;
        registerData['address'] =
            "${locationsBloc.currentCheckOutLocation!.address1} ${locationsBloc.currentCheckOutLocation!.address2}";
      }
      registerData['country_code'] = '';
      registerData['status'] = 'online';
      registerData['is_male'] = authBloc.isWomen ? "0" : "1";
      if (Util.getUserType() == UserEnum.NURSE.name.toLowerCase()) {
        registerData['user_type'] = authBloc.isNurse ? "nurse" : "assistant";
        if (authBloc.license != null)
          registerData['license'] = authBloc.license;
        if (authBloc.certificate != null)
          registerData['certificate'] = authBloc.certificate;
        if (authBloc.nurseID != null)
          registerData['nurseID'] = authBloc.nurseID;
        if (authBloc.associationCard != null)
          registerData['associationCard'] = authBloc.associationCard;
        if (authBloc.relatedJobId != null)
          registerData['related_job_id'] = authBloc.relatedJobId;
        if (authBloc.avatar != null) registerData['avatar'] = authBloc.avatar;
        if (authBloc.languageList != null)
          registerData['languages'] = jsonEncode(authBloc.languageList);
        if (authBloc.educationList != null)
          registerData['education'] = jsonEncode(authBloc.educationList);
        if (authBloc.publicationsList != null)
          registerData['publications'] = jsonEncode(authBloc.publicationsList);
        if (authBloc.coursesList != null)
          registerData['courses'] = jsonEncode(authBloc.coursesList);
      } else {
        registerData['user_type'] = Util.getUserType();
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DMUtil.getWC(),
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {},
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const AppBarWithRadius(
                enableBackIcon: true,
              ),
              SizedBox(
                height: AppStyle.paddingFromTop.h,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w),
                child: Column(
                  children: [
                    CustomText(
                      text: translate("signup.write_code"),
                      fontSize: AppStyle.small.sp,
                      fontFamily: primaryFontSemiBold,
                      color: DMUtil.getD2C(),
                    ),
                    CustomText(
                      text:
                          "${translate("signup.code_sent")} \n ${widget.data['phone'] ?? widget.data['email']}",
                      fontSize: AppStyle.small.sp,
                      color: DMUtil.getD2C(),
                      alignCenter: true,
                      fontFamily: primaryFontSemiBold,
                      maxLine: 3,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                        key: formKey,
                        child: Directionality(
                          textDirection: SharedPref.preferences
                                      .getPreferenceString(
                                          Constants.userLang) ==
                                  "ar"
                              ? TextDirection.ltr
                              : TextDirection.ltr,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 60.w),
                              child: PinCodeTextField(
                                appContext: context,
                                pastedTextStyle: TextStyle(
                                  color: Colors.green.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                                length: 4,
                                obscureText: false,
                                obscuringCharacter: '*',
                                animationType: AnimationType.slide,
                                validator: (v) {
                                  if (v!.length < 4) {
                                    return "";
                                  } else {
                                    return null;
                                  }
                                },
                                pinTheme: PinTheme(
                                  borderWidth: 0,
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  fieldHeight: 44.w,
                                  fieldWidth: 38.w,
                                  activeFillColor: kBackGround,
                                  inactiveColor: Colors.white,
                                  inactiveFillColor: kBackGround,
                                  selectedFillColor: kBackGround,
                                  disabledColor: Colors.white,
                                ),
                                // cursorColor: Colors.black,
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                textStyle:
                                    const TextStyle(fontSize: 20, height: 1.6),
                                // backgroundColor: Colors.white,
                                enableActiveFill: true,
                                errorAnimationController: errorController,
                                controller: textEditingController,
                                keyboardType: TextInputType.number,

                                onCompleted: (v) {
                                  debugPrint("Completed");
                                },
                                onChanged: (value) {
                                  debugPrint(value);
                                  setState(() {
                                    currentText = value;
                                  });
                                },
                                beforeTextPaste: (text) {
                                  debugPrint("Allowing to paste $text");
                                  return true;
                                },
                              )),
                        )),
                    Text(
                      hasError ? translate("signup.fill_all") : "",
                      style: const TextStyle(
                          color: kPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 25.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (sendVerify == false) return;
                            await SmsApi.sendOtp(
                                provider: widget.data['email'] ??
                                    widget.data['phone'],
                                isEmail: widget.data['email'] != null,
                                ctx: context);
                            setState(() {
                              sendVerify = false;
                            });
                            Timer(const Duration(seconds: 10), () {
                              setState(() {
                                sendVerify = true;
                              });
                            });
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: translate("signup.not_get_code"),
                                style: TextStyle(
                                    fontFamily: primaryFontSemiBold,
                                    color: DMUtil.getD2C(),
                                    fontSize: AppStyle.small.sp),
                                children: [
                                  TextSpan(
                                    text: " ${translate("signup.resend")}",
                                    recognizer: onTapRecognizer,
                                    style: TextStyle(
                                        color: sendVerify == false
                                            ? DMUtil.getOpacity()
                                            : DMUtil.getPC(),
                                        fontSize: AppStyle.small.sp),
                                  )
                                ]),
                          ),
                        ),
                        BlocListener<AuthBloc, AuthState>(
                          listener: (ctx, state) {
                            var bloc = AuthBloc.get(ctx);
                            if (state is RegistrationPendingState) {
                              SnackBarBuilder.showFeedBackMessage(
                                  context, state.message, Colors.green);
                              Util.pushPageAndRemoveRoutes(
                                  const LoginScreen(fromRegistration: true),
                                  context);
                            } else if (state is RegisterSuccessfullyState &&
                                state.response.isSuccess == true) {
                              SnackBarBuilder.showFeedBackMessage(
                                  context, bloc.resMsg, Colors.green);
                              Util.pushPageAndRemoveRoutes(
                                  const LoginScreen(fromRegistration: true),
                                  context);
                            } else {
                              SnackBarBuilder.showFeedBackMessage(
                                  context, bloc.resMsg, Colors.red);
                              if (bloc.resMsg
                                  .toString()
                                  .trim()
                                  .contains(translate("toast.sign_wrong"))) {
                                Util.pushPageAndRemoveRoutes(
                                    const NewExperienceScreen(), context);
                              }
                            }
                          },
                          listenWhen: (ctx, state) =>
                              state is RegistrationPendingState ||
                              state is RegisterSuccessfullyState ||
                              state is RegisterFailedState,
                          child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (ctx, state) {
                              var bloc = AuthBloc.get(ctx);
                              if (state is LogInLoadingState)
                                return CircularProgressIndicator(
                                  backgroundColor: DMUtil.getPC(),
                                );
                              if (state is RegisterLoadingState)
                                return CircularProgressIndicator(
                                  backgroundColor: DMUtil.getPC(),
                                );
                              return InkWell(
                                onTap: () async {
                                  var otp = textEditingController.text.trim();
                                  if (otp.isEmpty) {
                                    SnackBarBuilder.showFeedBackMessage(
                                        context,
                                        translate("toast.field_empty"),
                                        Colors.red);
                                    return;
                                  }
                                  //  if(await Util.verifyCode(otp)) {
                                  if (widget.isRegister) {
                                    bloc.add(RegisterEvent(user: registerData));
                                  } else if (widget.isLogin != null &&
                                      widget.isLogin == true) {
                                    bloc.add(LogInEvent(user: widget.data));
                                  } else {
                                    Util.pushPage(
                                        const ResetPassword(), context);
                                  }
                                  //  }else{
                                  //    SnackBarBuilder.showFeedBackMessage(context, translate("toast.verification_code"), Colors.red);
                                  //  }
                                },
                                child: CircleAvatar(
                                  backgroundColor: DMUtil.getPC(),
                                  radius: 20.w,
                                  child: Icon(
                                    Icons.arrow_forward_outlined,
                                    color: Colors.white,
                                    size: 20.w,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
