// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/widgets/nurse_widgets/edit_info_list.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_event.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';
import 'package:icare/features/authentication/presentation/cubit/registration_cubit.dart';
import 'package:icare/features/authentication/presentation/widgets/nurse/add_btn_row.dart';
import 'package:icare/features/authentication/presentation/widgets/nurse/app_bar_nurse_create_account.dart';
import 'package:icare/features/authentication/presentation/screens/login.dart';
import 'package:icare/features/authentication/presentation/screens/nurse/create_nurse_account.dart';
import 'package:icare/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:icare/features/root_app/screens/welcome_screens/new_experience_screen.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_dialogs.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';

class CompleteNurseRegisterDataScreen extends StatelessWidget {
  const CompleteNurseRegisterDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocListener<AuthBloc, AuthState>(
          listener: (ctx, state) {
            var bloc = AuthBloc.get(ctx);
            if (state is RegistrationPendingState) {
              RegistrationCubit.get(ctx).reset();
              CreateNurseAccountScreen.clearControllers();
              SnackBarBuilder.showFeedBackMessage(
                  context, state.message, Colors.green);
              Util.pushPageAndRemoveRoutes(
                  const LoginScreen(fromRegistration: true), context);
            } else if (state is RegisterSuccessfullyState &&
                state.response.isSuccess == true) {
              RegistrationCubit.get(ctx).reset();
              CreateNurseAccountScreen.clearControllers();
              SnackBarBuilder.showFeedBackMessage(
                  context, bloc.resMsg, Colors.green);
              Util.pushPageAndRemoveRoutes(
                  const LoginScreen(fromRegistration: true), context);
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
              var authBloc = AuthBloc.get(ctx);
              // Read registration data from RegistrationCubit
              var regState = RegistrationCubit.get(ctx).state;

              if (state is LogInLoadingState || state is RegisterLoadingState) {
                return CircularProgressIndicator(
                  backgroundColor: DMUtil.getPC(),
                );
              }
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
                  // Validation uses RegistrationCubit state
                  if (regState.languageList == null ||
                      regState.languageList!.isEmpty) {
                    SnackBarBuilder.showFeedBackMessage(
                        context, translate("toast.lang_missing"), Colors.red);
                    return;
                  }
                  if (regState.educationList == null ||
                      regState.educationList!.isEmpty) {
                    SnackBarBuilder.showFeedBackMessage(
                        context, translate("toast.edu_missing"), Colors.red);
                    return;
                  }
                  if (regState.publicationsList == null ||
                      regState.publicationsList!.isEmpty) {
                    SnackBarBuilder.showFeedBackMessage(context,
                        translate("toast.experience_missing"), Colors.red);
                    return;
                  }
                  if (regState.coursesList == null ||
                      regState.coursesList!.isEmpty) {
                    SnackBarBuilder.showFeedBackMessage(context,
                        translate("toast.courses_missing"), Colors.red);
                    return;
                  }

                  // Get LocationsBloc for location data
                  var locationsBloc = LocationsBloc.get(context);

                  // Build registerData — reads from RegistrationCubit (fixed)
                  Map<String, dynamic> registerData = {
                    'name': regState.nurse?.userData!.userName.toString(),
                    'email': regState.nurse?.userData!.email.toString(),
                    'phone': regState.nurse?.userData!.phoneNumber.toString(),
                    'password': CreateNurseAccountScreen
                        .passwordTextEditingController.text,
                  };

                  // Add location data
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

                  // User-type specific data — reads registration files from cubit
                  if (authBloc.isDoctor) {
                    registerData['user_type'] = "doctor";
                    if (regState.nurseID != null) {
                      registerData['nurseID'] = regState.nurseID;
                    }
                    if (regState.selectedSpecialtyId != null) {
                      registerData['specialties_id'] =
                          regState.selectedSpecialtyId;
                    }
                  } else {
                    registerData['user_type'] =
                        authBloc.isNurse ? "nurse" : "assistant";
                    if (regState.nurseID != null) {
                      registerData['nurseID'] = regState.nurseID;
                    }
                  }

                  if (regState.license != null) {
                    registerData['license'] = regState.license;
                  }
                  if (regState.certificate != null) {
                    registerData['certificate'] = regState.certificate;
                  }
                  if (regState.associationCard != null) {
                    registerData['associationCard'] = regState.associationCard;
                  }
                  if (regState.relatedJobId != null) {
                    registerData['related_job_id'] = regState.relatedJobId;
                  }
                  if (regState.avatar != null) {
                    registerData['avatar'] = regState.avatar;
                  }
                  if (regState.languageList != null) {
                    registerData['languages'] =
                        jsonEncode(regState.languageList);
                  }
                  if (regState.educationList != null) {
                    registerData['education'] =
                        jsonEncode(regState.educationList);
                  }
                  if (regState.publicationsList != null) {
                    registerData['publications'] =
                        jsonEncode(regState.publicationsList);
                  }
                  if (regState.coursesList != null) {
                    registerData['courses'] = jsonEncode(regState.coursesList);
                  }

                  // Dispatch register to AuthBloc (auth concern only)
                  authBloc.add(RegisterEvent(user: registerData));
                },
              );
            },
          )),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const AppBarNurseCreateAccount(
              showCircleImg: false,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppStyle.paddingFromH.w, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddRowWithTitle(
                    onTap: () async {
                      var res = await CustomDialogs.addNewValue(context);
                      if (res != null && res != "") {
                        var regCubit = RegistrationCubit.get(context);
                        List<String> updated =
                            List.from(regCubit.state.languageList ?? []);
                        if (updated.contains(res)) return;
                        updated.add(res);
                        regCubit.updateLanguageList(updated);
                      }
                    },
                    title: translate("nurse.languages"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const NurseOptionsValueRow(
                    listType: "languages",
                  ),
                  Divider(
                    height: 30.w,
                  ),
                  AddRowWithTitle(
                    onTap: () async {
                      var res = await CustomDialogs.addNewValue(context);
                      if (res != null && res != "") {
                        var regCubit = RegistrationCubit.get(context);
                        List<String> updated =
                            List.from(regCubit.state.educationList ?? []);
                        if (updated.contains(res)) return;
                        updated.add(res);
                        regCubit.updateEducationList(updated);
                      }
                    },
                    title: translate("nurse.education"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const NurseOptionsValueRow(
                    listType: "education",
                  ),
                  Divider(
                    height: 30.w,
                  ),
                  AddRowWithTitle(
                    onTap: () async {
                      var res = await CustomDialogs.addNewValue(context);
                      if (res != null && res != "") {
                        var regCubit = RegistrationCubit.get(context);
                        List<String> updated =
                            List.from(regCubit.state.publicationsList ?? []);
                        if (updated.contains(res)) return;
                        updated.add(res);
                        regCubit.updatePublicationsList(updated);
                      }
                    },
                    title: translate("nurse.experience_year"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const NurseOptionsValueRow(
                    listType: "publications",
                  ),
                  Divider(
                    height: 30.w,
                  ),
                  AddRowWithTitle(
                    onTap: () async {
                      var res = await CustomDialogs.addNewValue(context);
                      if (res != null && res != "") {
                        var regCubit = RegistrationCubit.get(context);
                        List<String> updated =
                            List.from(regCubit.state.coursesList ?? []);
                        if (updated.contains(res)) return;
                        updated.add(res);
                        regCubit.updateCoursesList(updated);
                      }
                    },
                    title: translate("nurse.courses"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const NurseOptionsValueRow(
                    listType: "courses",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
