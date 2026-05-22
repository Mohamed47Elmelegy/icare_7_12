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
import 'package:icare/features/authentication/presentation/screens/login.dart';
import 'package:icare/features/authentication/presentation/screens/nurse/create_nurse_account.dart';
import 'package:icare/features/authentication/presentation/widgets/nurse/add_btn_row.dart';
import 'package:icare/features/authentication/presentation/widgets/nurse/app_bar_nurse_create_account.dart';
import 'package:icare/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_dialogs.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';

class CompleteDoctorRegisterDataScreen extends StatelessWidget {
  const CompleteDoctorRegisterDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DMUtil.getWC(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocListener<AuthBloc, AuthState>(
        listener: (ctx, state) {
          var bloc = AuthBloc.get(ctx);
          if (state is RegistrationPendingState) {
            RegistrationCubit.get(ctx).reset();
            CreateNurseAccountScreen.clearControllers();
            SnackBarBuilder.showFeedBackMessage(
              context,
              state.message,
              Colors.green,
            );
            Util.pushPageAndRemoveRoutes(
              const LoginScreen(fromRegistration: true),
              context,
            );
          } else if (state is RegisterSuccessfullyState &&
              state.response.isSuccess == true) {
            RegistrationCubit.get(ctx).reset();
            CreateNurseAccountScreen.clearControllers();
            SnackBarBuilder.showFeedBackMessage(
              context,
              bloc.resMsg,
              Colors.green,
            );
            Util.pushPageAndRemoveRoutes(
              const LoginScreen(fromRegistration: true),
              context,
            );
          } else if (state is RegisterFailedState) {
            SnackBarBuilder.showFeedBackMessage(
              context,
              bloc.resMsg,
              Colors.red,
            );
          }
        },
        listenWhen: (ctx, state) =>
            state is RegistrationPendingState ||
            state is RegisterSuccessfullyState ||
            state is RegisterFailedState,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (ctx, state) {
            var authBloc = AuthBloc.get(ctx);

            if (state is LogInLoadingState || state is RegisterLoadingState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: DMUtil.getPC(),
                  ),
                  SizedBox(height: 10.h),
                  CustomText(
                    text: "جاري رفع المستندات...",
                    fontSize: AppStyle.small.sp,
                    color: DMUtil.getD2C(),
                  ),
                ],
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
                // Read the latest RegistrationCubit state. The enclosing
                // BlocBuilder only rebuilds on AuthBloc changes, so the
                // `regState` captured above goes stale the moment the user
                // adds a language/education/etc. entry.
                final regState = RegistrationCubit.get(context).state;
                // ✅ Validate required files from RegistrationCubit (fixed)
                if (regState.license == null ||
                    regState.certificate == null ||
                    regState.nurseID == null) {
                  SnackBarBuilder.showFeedBackMessage(
                    context,
                    "يرجى رفع جميع المستندات المطلوبة (الترخيص، الشهادة، بطاقة الهوية)",
                    Colors.red,
                  );
                  return;
                }

                if (!regState.isInfoCompleted) {
                  SnackBarBuilder.showFeedBackMessage(
                    context,
                    translate("toast.field_empty"),
                    Colors.red,
                  );
                  return;
                }

                if (regState.selectedSpecialtyId == null) {
                  SnackBarBuilder.showFeedBackMessage(
                    context,
                    translate("toast.specialty_required"),
                    Colors.red,
                  );
                  return;
                }

                // Get LocationsBloc for location data
                var locationsBloc = LocationsBloc.get(context);

                // Build register data — reads from RegistrationCubit (fixed)
                Map<String, dynamic> registerData = {
                  'name': regState.nurse?.userData!.userName.toString(),
                  'email': regState.nurse?.userData!.email.toString(),
                  'phone': regState.nurse?.userData!.phoneNumber.toString(),
                  'password': CreateNurseAccountScreen
                      .passwordTextEditingController.text
                      .trim(),
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

                // Add doctor-specific data
                registerData['user_type'] = 'doctor';

                // ✅ Add specialty from RegistrationCubit (fixed)
                if (regState.selectedSpecialtyId != null) {
                  registerData['specialties_id'] = regState.selectedSpecialtyId;
                }

                // Add files from RegistrationCubit (fixed)
                if (regState.avatar != null) {
                  registerData['avatar'] = regState.avatar;
                }
                if (regState.license != null) {
                  registerData['license'] = regState.license;
                }
                if (regState.certificate != null) {
                  registerData['certificate'] = regState.certificate;
                }
                if (regState.nurseID != null) {
                  registerData['nurseID'] = regState.nurseID;
                }
                if (regState.associationCard != null) {
                  registerData['associationCard'] = regState.associationCard;
                }

                // Add professional data from RegistrationCubit (fixed)
                if (regState.languageList != null &&
                    regState.languageList!.isNotEmpty) {
                  registerData['languages'] = jsonEncode(regState.languageList);
                }
                if (regState.educationList != null &&
                    regState.educationList!.isNotEmpty) {
                  registerData['education'] =
                      jsonEncode(regState.educationList);
                }
                if (regState.publicationsList != null &&
                    regState.publicationsList!.isNotEmpty) {
                  registerData['publications'] =
                      jsonEncode(regState.publicationsList);
                }
                if (regState.coursesList != null &&
                    regState.coursesList!.isNotEmpty) {
                  registerData['courses'] = jsonEncode(regState.coursesList);
                }

                // Send registration request to AuthBloc (auth concern only)
                authBloc.add(RegisterEvent(user: registerData));
              },
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppBarNurseCreateAccount(
              showCircleImg: false,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppStyle.paddingFromH.w,
                vertical: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  CustomText(
                    text: "إكمال بيانات الطبيب",
                    fontSize: AppStyle.large.sp,
                    fontWeight: FontWeight.bold,
                    color: DMUtil.getD2C(),
                  ),
                  SizedBox(height: 10.h),

                  // Languages
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
                  const SizedBox(height: 10),
                  const NurseOptionsValueRow(listType: "languages"),
                  Divider(height: 30.w),

                  // Education
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
                  const SizedBox(height: 10),
                  const NurseOptionsValueRow(listType: "education"),
                  Divider(height: 30.w),

                  // Publications
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
                  const SizedBox(height: 10),
                  const NurseOptionsValueRow(listType: "publications"),
                  Divider(height: 30.w),

                  // Courses
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
                  const SizedBox(height: 10),
                  const NurseOptionsValueRow(listType: "courses"),

                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
