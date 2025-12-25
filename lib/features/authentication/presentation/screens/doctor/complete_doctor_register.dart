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
import 'package:icare/features/authentication/presentation/screens/login.dart';
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
            var bloc = AuthBloc.get(ctx);
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
                // ✅ Validate required files first
                if (bloc.license == null ||
                    bloc.certificate == null ||
                    bloc.nurseID == null) {
                  SnackBarBuilder.showFeedBackMessage(
                    context,
                    "يرجى رفع جميع المستندات المطلوبة (الترخيص، الشهادة، بطاقة الهوية)",
                    Colors.red,
                  );
                  return;
                }

                // Specialty validation removed - will be set after login

                if (bloc.checkNurseRegisterInfoCompleted() == false) {
                  SnackBarBuilder.showFeedBackMessage(
                    context,
                    translate("toast.field_empty"),
                    Colors.red,
                  );
                  return;
                }

                // Get LocationsBloc for location data
                var locationsBloc = LocationsBloc.get(context);

                // Build register data
                Map<String, dynamic> registerData = {
                  'name': bloc.nurse?.userData!.userName.toString(),
                  'email': bloc.nurse?.userData!.email.toString(),
                  'phone': bloc.nurse?.userData!.phoneNumber.toString(),
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
                registerData['is_male'] = bloc.isWomen ? "0" : "1";

                // Add doctor-specific data
                registerData['user_type'] = 'doctor';

                // ✅ Add specialty if selected (optional)
                if (bloc.selectedSpecialtyId != null) {
                  registerData['specialties_id'] = bloc.selectedSpecialtyId;
                }

                // Add files
                if (bloc.avatar != null) {
                  registerData['avatar'] = bloc.avatar;
                }
                if (bloc.license != null) {
                  registerData['license'] = bloc.license;
                }
                if (bloc.certificate != null) {
                  registerData['certificate'] = bloc.certificate;
                }
                if (bloc.nurseID != null) {
                  registerData['nurseID'] = bloc.nurseID;
                }
                if (bloc.associationCard != null) {
                  registerData['associationCard'] = bloc.associationCard;
                }

                // Add professional data
                if (bloc.languageList != null &&
                    bloc.languageList!.isNotEmpty) {
                  registerData['languages'] = jsonEncode(bloc.languageList);
                }
                if (bloc.educationList != null &&
                    bloc.educationList!.isNotEmpty) {
                  registerData['education'] = jsonEncode(bloc.educationList);
                }
                if (bloc.publicationsList != null &&
                    bloc.publicationsList!.isNotEmpty) {
                  registerData['publications'] =
                      jsonEncode(bloc.publicationsList);
                }
                if (bloc.coursesList != null && bloc.coursesList!.isNotEmpty) {
                  registerData['courses'] = jsonEncode(bloc.coursesList);
                }

                // Send registration request
                bloc.add(RegisterEvent(user: registerData));
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
                  // CustomText(
                  //   text:
                  //       "يرجى إكمال البيانات المهنية (يمكنك إضافة التخصص لاحقاً من الحساب)",
                  //   fontSize: AppStyle.small.sp,
                  //   color: DMUtil.getD2C().withValues(alpha: 0.7),
                  // ),
                  // SizedBox(height: 20.h),

                  // // Specialty Selection (Optional)
                  // CustomText(
                  //   text: "التخصص (اختياري)",
                  //   fontSize: AppStyle.average.sp,
                  //   fontWeight: FontWeight.w600,
                  //   color: DMUtil.getD2C(),
                  // ),
                  // SizedBox(height: 10.h),
                  // const SpecialtyListDropDown(),
                  // SizedBox(height: 20.h),

                  // Languages
                  AddRowWithTitle(
                    onTap: () async {
                      var res = await CustomDialogs.addNewValue(context);
                      if (res != null && res != "") {
                        var bloc = AuthBloc.get(context);
                        bloc.languageList ??= [];
                        int index = bloc.languageList!
                            .indexWhere((element) => element == res);
                        if (index != -1) return;
                        bloc.languageList!.add(res);
                        bloc.add(UpdateNurseRegisterDataEvent(
                            languageList: bloc.languageList));
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
                        var bloc = AuthBloc.get(context);
                        bloc.educationList ??= [];
                        int index = bloc.educationList!
                            .indexWhere((element) => element == res);
                        if (index != -1) return;
                        bloc.educationList!.add(res);
                        bloc.add(UpdateNurseRegisterDataEvent(
                            educationList: bloc.educationList));
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
                        var bloc = AuthBloc.get(context);
                        bloc.publicationsList ??= [];
                        int index = bloc.publicationsList!
                            .indexWhere((element) => element == res);
                        if (index != -1) return;
                        bloc.publicationsList!.add(res);
                        bloc.add(UpdateNurseRegisterDataEvent(
                            publicationsList: bloc.publicationsList));
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
                        var bloc = AuthBloc.get(context);
                        bloc.coursesList ??= [];
                        int index = bloc.coursesList!
                            .indexWhere((element) => element == res);
                        if (index != -1) return;
                        bloc.coursesList!.add(res);
                        bloc.add(UpdateNurseRegisterDataEvent(
                            coursesList: bloc.coursesList));
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
