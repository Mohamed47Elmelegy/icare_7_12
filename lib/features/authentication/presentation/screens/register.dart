// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:icare/core/strings/enum/user_enum.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/presentation/widgets/already_have_account.dart';
import 'package:icare/features/authentication/presentation/widgets/gender_row.dart';
import 'package:icare/features/authentication/presentation/widgets/nurse/app_bar_nurse_create_account.dart';
import 'package:icare/features/authentication/presentation/widgets/patient_kind_drop_down.dart';
import 'package:icare/features/authentication/presentation/screens/login.dart';
import 'package:icare/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:icare/features/locations/presentation/widgets/city_list_drop_down.dart';
import 'package:icare/features/locations/presentation/widgets/current_location.dart';
import 'package:icare/features/locations/presentation/widgets/governorate_type_drop_down.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_event.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  static final TextEditingController emailTextEditingController =
      TextEditingController();
  static final TextEditingController nameTextEditingController =
      TextEditingController();
  static final TextEditingController phoneTextEditingController =
      TextEditingController();
  static final TextEditingController passwordTextEditingController =
      TextEditingController();
  static final TextEditingController cityTextEditingController =
      TextEditingController();
  static final TextEditingController addressTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DMUtil.getWC(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
          builder: (ctx, state) {
            if (state is LogInLoadingState)
              return CircularProgressIndicator(
                backgroundColor: DMUtil.getPC(),
              );
            return CustomButton(
              height: 45.h,
              width: 300.w,
              circular: 10,
              widget: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: translate("signup.signup"),
                    color: Colors.white,
                    fontSize: AppStyle.average.sp - 1,
                    fontWeight: FontWeight.w600,
                    alignCenter: true,
                  ),
                  Icon(
                    Icons.arrow_forward_outlined,
                    size: 20.w,
                    color: DMUtil.getWC(),
                  ),
                ],
              ),
              color: DMUtil.getPC(),
              onPressed: () async {
                var phone = phoneTextEditingController.text.trim();
                var email = emailTextEditingController.text.trim();
                if (validateForm(context: context)) {
                  var authBloc = AuthBloc.get(context);
                  var locationsBloc = LocationsBloc.get(context);

                  // Build register data similar to verification_code.dart
                  Map<String, dynamic> registerData = {
                    'name': nameTextEditingController.text.trim(),
                    'email': email,
                    'phone': phone,
                    'password': passwordTextEditingController.text.trim(),
                  };

                  registerData['city'] = locationsBloc.city;
                  registerData['governorate'] = locationsBloc.governorate;
                  if (locationsBloc.currentCheckOutLocation != null) {
                    registerData['latitude'] =
                        locationsBloc.currentCheckOutLocation!.lat;
                    registerData['longitude'] =
                        locationsBloc.currentCheckOutLocation!.long;
                    registerData['address'] =
                        "${locationsBloc.currentCheckOutLocation!.address1} ${locationsBloc.currentCheckOutLocation!.address2}";
                  }
                  registerData['country_code'] = '';
                  registerData['status'] = 'online';
                  registerData['is_male'] = authBloc.isWomen ? "0" : "1";
                  if (Util.getUserType() == UserEnum.NURSE.name.toLowerCase()) {
                    registerData['user_type'] =
                        authBloc.isNurse ? "nurse" : "assistant";
                    if (authBloc.license != null)
                      registerData['license'] = authBloc.license;
                    if (authBloc.certificate != null)
                      registerData['certificate'] = authBloc.certificate;
                    if (authBloc.nurseID != null)
                      registerData['nurseID'] = authBloc.nurseID;
                    if (authBloc.associationCard != null)
                      registerData['associationCard'] =
                          authBloc.associationCard;
                    if (authBloc.relatedJobId != null)
                      registerData['related_job_id'] = authBloc.relatedJobId;
                    if (authBloc.avatar != null)
                      registerData['avatar'] = authBloc.avatar;
                    if (authBloc.languageList != null)
                      registerData['languages'] =
                          jsonEncode(authBloc.languageList);
                    if (authBloc.educationList != null)
                      registerData['education'] =
                          jsonEncode(authBloc.educationList);
                    if (authBloc.publicationsList != null)
                      registerData['publications'] =
                          jsonEncode(authBloc.publicationsList);
                    if (authBloc.coursesList != null)
                      registerData['courses'] =
                          jsonEncode(authBloc.coursesList);
                  } else {
                    registerData['user_type'] = Util.getUserType();
                  }

                  authBloc.add(RegisterEvent(user: registerData));
                } else {
                  SnackBarBuilder.showFeedBackMessage(
                      context, translate("toast.field_empty"), Colors.red);
                }
              },
            );
          },
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (ctx, state) {
            var bloc = AuthBloc.get(ctx);
            if (state is RegistrationPendingState) {
              // Clear password for security
              passwordTextEditingController.text = "";
              // Show success message
              SnackBarBuilder.showFeedBackMessage(
                  context, state.message, Colors.green);
              // Navigate to login screen with pending flag
              Util.pushPageAndRemoveRoutes(
                  const LoginScreen(fromRegistration: true), context);
            } else if (state is RegisterSuccessfullyState &&
                state.response.isSuccess == true) {
              // Legacy success case (if backend returns success)
              passwordTextEditingController.text = "";
              SnackBarBuilder.showFeedBackMessage(
                  context, bloc.resMsg, Colors.green);
              Util.pushPageAndRemoveRoutes(
                  const LoginScreen(fromRegistration: true), context);
            } else if (state is RegisterFailedState) {
              SnackBarBuilder.showFeedBackMessage(
                  context, bloc.resMsg, Colors.red);
            }
          },
          listenWhen: (ctx, state) =>
              state is RegistrationPendingState ||
              state is RegisterSuccessfullyState ||
              state is RegisterFailedState,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppBarNurseCreateAccount(
                  showCircleImg: false,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppStyle.paddingFromH.w, vertical: 15),
                  child: Column(
                    children: [
                      const PatientKindListDropDown(),
                      SizedBox(
                        height: 10.w,
                      ),
                      CustomTextFromField(
                        hasBorder: true,
                        borderWidth: 1,
                        borderColor: DMUtil.getD2C(),
                        labelText: '',
                        height: 45,
                        hintText: translate("signup.username"),
                        radius: 10,
                        onChanged: (val) {},
                        onFieldSubmitted: (val) {},
                        textEditingController: nameTextEditingController,
                        cursorColor: kPrimary,
                        validator: () {},
                        prefixIcon: null,
                        obscureText: false,
                        suffixIcon: Icon(
                          Icons.person,
                          color: DMUtil.getPC(),
                          size: 20.w,
                        ),
                        isLabelError: false,
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      GenderRow(
                        txtColor: DMUtil.getD2C(),
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      CustomTextFromField(
                        hasBorder: true,
                        borderWidth: 1,
                        borderColor: DMUtil.getD2C(),
                        labelText: '',
                        height: 45,
                        hintText: translate("signup.phone"),
                        radius: 10,
                        onChanged: (val) {},
                        onFieldSubmitted: (val) {},
                        textInputType: TextInputType.phone,
                        textEditingController: phoneTextEditingController,
                        cursorColor: kPrimary,
                        validator: () {},
                        prefixIcon: null,
                        obscureText: false,
                        suffixIcon: Icon(
                          Icons.phone,
                          color: DMUtil.getPC(),
                          size: 20.w,
                        ),
                        isLabelError: false,
                      ),
                      // IntlPhoneField(
                      //   controller: phoneTextEditingController,
                      //   decoration: InputDecoration(
                      //     labelText:  translate("signup.phone"),
                      //     labelStyle: TextStyle(color: DMUtil.getD2C()),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //       borderSide: BorderSide(
                      //           width: 1,color: DMUtil.getOpacity()
                      //       ),
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //       borderSide: BorderSide(
                      //           width: 1,color: DMUtil.getOpacity()
                      //       ),
                      //     ),
                      //     border: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //           width: 1,color: DMUtil.getOpacity()
                      //       ),
                      //     ),
                      //   ),
                      //   initialCountryCode: 'EG',
                      //   onChanged: (phone) {},
                      //   onCountryChanged: (val)=>AuthBloc.get(context).add(UpdatePhoneCountryEvent(code: val.toString().trim())),
                      // ),
                      SizedBox(
                        height: 10.w,
                      ),
                      CustomTextFromField(
                        hasBorder: true,
                        borderWidth: 1,
                        borderColor: DMUtil.getD2C(),
                        labelText: '',
                        height: 45,
                        hintText: translate("signup.email"),
                        radius: 10,
                        onChanged: (val) {},
                        onFieldSubmitted: (val) {},
                        textEditingController: emailTextEditingController,
                        cursorColor: kPrimary,
                        validator: () {},
                        prefixIcon: null,
                        obscureText: false,
                        suffixIcon: Icon(
                          Icons.email,
                          color: DMUtil.getPC(),
                          size: 20.w,
                        ),
                        isLabelError: false,
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (ctx, state) {
                          var bloc = AuthBloc.get(ctx);
                          bool showPassword = bloc.showPassword;
                          return CustomTextFromField(
                            hasBorder: true,
                            borderWidth: 1,
                            borderColor: DMUtil.getD2C(),
                            labelText: '',
                            height: 45,
                            hintText: translate("signup.password"),
                            radius: 10,
                            // onChanged: (val)=> bloc.add(EnableAuthButtonEvent(enable: validateForm())),
                            // onFieldSubmitted: (val)=> bloc.add(EnableAuthButtonEvent(enable: validateForm())),
                            textEditingController:
                                passwordTextEditingController,
                            cursorColor: kPrimary,
                            validator: () {},
                            prefixIcon: null,
                            obscureText: !showPassword,
                            suffixIcon: InkWell(
                                onTap: () => ctx
                                    .read<AuthBloc>()
                                    .add(const ChangePasswordEvent()),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 7),
                                  child: Icon(
                                    showPassword == true
                                        ? CupertinoIcons.eye
                                        : CupertinoIcons.eye_slash,
                                    color: DMUtil.getPC(),
                                    size: 20.w,
                                  ),
                                )),
                            isLabelError: false,
                          );
                        },
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      const GovernorateListDropDown(),
                      SizedBox(
                        height: 10.w,
                      ),
                      const CityListDropDown(),
                      SizedBox(
                        height: 10.w,
                      ),
                      const CurrentLocationDetails(),

                      const SizedBox(
                        height: 20,
                      ),

                      const AlreadyHaveAnAccountWidget(),
                      const SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  bool validatePhoneInput(
      bool registerByPhone, String phone, BuildContext context) {
    if (registerByPhone && phone.isNotEmpty) {
      String? txt = Util.validatePhone(phone);
      if (txt != null) {
        SnackBarBuilder.showFeedBackMessage(context, txt, DMUtil.getRED());
        return false;
      }
    }
    return true;
  }

  validateForm({BuildContext? context}) {
    if (!emailTextEditingController.text.contains("@")) {
      if (context != null)
        SnackBarBuilder.showFeedBackMessage(
            context, translate("toast.email_invalid"), Colors.red);
      return false;
    }

    if (emailTextEditingController.text.trim().isNotEmpty &&
        phoneTextEditingController.text.trim().isNotEmpty &&
        nameTextEditingController.text.trim().isNotEmpty &&
        passwordTextEditingController.text.trim().isNotEmpty) {
      return true;
    }
    return false;
  }
}
