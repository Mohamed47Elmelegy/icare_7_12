// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';
import 'package:icare/features/authentication/presentation/widgets/gender_row.dart';
import 'package:icare/features/authentication/presentation/widgets/nurse/nurse_type.dart';
import 'package:path/path.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/core/utils/upload_document.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';
import 'package:icare/features/authentication/presentation/screens/nurse/next_step_nurse_register.dart';
import 'package:icare/features/authentication/presentation/screens/doctor/complete_doctor_register.dart';
import 'package:icare/features/authentication/presentation/widgets/already_have_account.dart';
import 'package:icare/features/authentication/presentation/widgets/nurse/app_bar_nurse_create_account.dart';
import 'package:icare/features/authentication/presentation/widgets/upload_widget.dart';
import 'package:icare/features/locations/presentation/widgets/city_list_drop_down.dart';
import 'package:icare/features/locations/presentation/widgets/current_location.dart';
import 'package:icare/features/locations/presentation/widgets/governorate_type_drop_down.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
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
import 'package:intl_phone_field/intl_phone_field.dart';

class CreateNurseAccountScreen extends StatelessWidget {
  const CreateNurseAccountScreen({super.key});
  static final TextEditingController emailTextEditingController =
      TextEditingController();
  static final TextEditingController firstNameTextEditingController =
      TextEditingController();
  static final TextEditingController phoneTextEditingController =
      TextEditingController();
  static final TextEditingController passwordTextEditingController =
      TextEditingController();
  static final TextEditingController ageTextEditingController =
      TextEditingController();
  static final TextEditingController cityTextEditingController =
      TextEditingController();
  static final TextEditingController addressTextEditingController =
      TextEditingController();
  static final TextEditingController licenceTextEditingController =
      TextEditingController();
  static final TextEditingController certificateTextEditingController =
      TextEditingController();
  static final TextEditingController nurseIDTextEditingController =
      TextEditingController();
  static final TextEditingController associateTextEditingController =
      TextEditingController();
  static final TextEditingController relatedJobCardTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DMUtil.getWC(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
          builder: (ctx, state) {
            var bloc = AuthBloc.get(ctx);
            if (state is LogInLoadingState) {
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
                    text: translate("signup.complete"),
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
                if (bloc.avatar == null) {
                  SnackBarBuilder.showFeedBackMessage(
                      context, translate("toast.img_missing"), Colors.red);
                  return;
                }
                if (validateForm(context: context, bloc: bloc)) {
                  bloc.add(UpdateNurseRegisterDataEvent(
                    nurse: NurseEntity(
                      id: 0,
                      userData: UserService(
                          userName: firstNameTextEditingController.text.trim(),
                          email: emailTextEditingController.text.trim(),
                          phoneNumber: phoneTextEditingController.text.trim()),
                    ),
                  ));

                  // Navigate to appropriate screen based on user type
                  if (bloc.isDoctor) {
                    // No need to check specialties - will be set after login
                    Util.pushPage(
                        const CompleteDoctorRegisterDataScreen(), context);
                  } else {
                    Util.pushPage(
                        const CompleteNurseRegisterDataScreen(), context);
                  }
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
            // var bloc = AuthBloc.get(ctx);
            // if(state is RegisterSuccessfullyState && state.response.isSuccess==true){
            //     passwordTextEditingController.text = "";
            //     Util.getAllUserAppData(context: context);
            //     SnackBarBuilder.showFeedBackMessage(context, bloc.resMsg, Colors.green);
            //     Util.pushPageAndRemoveRoutes(const RootScreen(), context);
            // }else{
            //   SnackBarBuilder.showFeedBackMessage(context, bloc.resMsg, Colors.red);
            // }
          },
          listenWhen: (ctx, state) =>
              state is RegisterSuccessfullyState ||
              state is RegisterFailedState,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppBarNurseCreateAccount(
                  showCircleImg: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppStyle.paddingFromH.w, vertical: 15),
                  child: Column(
                    children: [
                      NurseType(
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
                        hintText: translate("signup.username"),
                        radius: 10,
                        onChanged: (val) {},
                        onFieldSubmitted: (val) {},
                        textEditingController: firstNameTextEditingController,
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
                      IntlPhoneField(
                        controller: phoneTextEditingController,
                        decoration: InputDecoration(
                          labelText: translate("signup.phone"),
                          labelStyle: TextStyle(color: DMUtil.getD2C()),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                width: 1, color: DMUtil.getOpacity()),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                width: 1, color: DMUtil.getOpacity()),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: DMUtil.getOpacity()),
                          ),
                        ),
                        initialCountryCode: 'EG',
                        onChanged: (phone) {},
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
                      // Specialty selection removed - will be set from account settings after login
                      // Similar to how nurses set their services after registration
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (ctx, state) {
                          var bloc = AuthBloc.get(ctx);
                          bool showPassword = bloc.showPassword;
                          if (bloc.registerByPhone == true) {
                            return const SizedBox.shrink();
                          }
                          return CustomTextFromField(
                              hasBorder: true,
                              borderWidth: 1,
                              borderColor: DMUtil.getD2C(),
                              labelText: '',
                              height: 45,
                              hintText: translate("signup.password"),
                              radius: 10,
                              // onChanged: (val)=> bloc.add(const EnableAuthButtonEvent(enable: false)),
                              // onFieldSubmitted: (val)=> bloc.add(const EnableAuthButtonEvent(enable: false)),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7),
                                    child: Icon(
                                      showPassword == true
                                          ? CupertinoIcons.eye
                                          : CupertinoIcons.eye_slash,
                                      color: DMUtil.getPC(),
                                      size: 20.w,
                                    ),
                                  )),
                              isLabelError: false);
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
                      SizedBox(
                        height: 10.w,
                      ),
                      GenderRow(
                        txtColor: DMUtil.getD2C(),
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      Stack(
                        alignment: Util.getLang() != "ar"
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        children: [
                          CustomTextFromField(
                            hasBorder: true,
                            borderWidth: 1,
                            borderColor: DMUtil.getD2C(),
                            labelText: '',
                            height: 46,
                            hintText: AuthBloc.get(context).isDoctor
                                ? translate("doctor.doctor_id")
                                : translate("nurse.nurse_id"),
                            radius: 10,
                            onChanged: (val) {},
                            onFieldSubmitted: (val) {},
                            textEditingController: nurseIDTextEditingController,
                            cursorColor: kPrimary,
                            enabled: false,
                            validator: () {},
                            prefixIcon: null,
                            obscureText: false,
                            suffixIcon: null,
                            isLabelError: false,
                          ),
                          InkWell(
                            onTap: () async {
                              final res = await getImage(ctx: context);
                              if (res == null) return;
                              final file = await cropImage(res);
                              if (file != null) {
                                nurseIDTextEditingController.text =
                                    _getFileName(file);
                                AuthBloc.get(context).add(
                                    UpdateNurseRegisterDataEvent(
                                        nurseID: file));
                              }
                            },
                            child: const UploadWidget(),
                          ),
                        ],
                      ),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (ctx, state) {
                          var bloc = AuthBloc.get(ctx);
                          if (!bloc.isNurse && !bloc.isDoctor) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 10.w,
                                ),
                                Stack(
                                  alignment: Util.getLang() != "ar"
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  children: [
                                    CustomTextFromField(
                                      hasBorder: true,
                                      borderWidth: 1,
                                      borderColor: DMUtil.getD2C(),
                                      labelText: '',
                                      height: 46,
                                      hintText: translate("nurse.related_job"),
                                      radius: 10,
                                      onChanged: (val) {},
                                      onFieldSubmitted: (val) {},
                                      textEditingController:
                                          relatedJobCardTextEditingController,
                                      enabled: false,
                                      cursorColor: kPrimary,
                                      validator: () {},
                                      prefixIcon: null,
                                      obscureText: false,
                                      suffixIcon: null,
                                      isLabelError: false,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final res =
                                            await getImage(ctx: context);
                                        if (res == null) return;
                                        final file = await cropImage(res);
                                        if (file != null) {
                                          relatedJobCardTextEditingController
                                              .text = _getFileName(file);
                                          AuthBloc.get(context).add(
                                              UpdateNurseRegisterDataEvent(
                                                  relatedJobId: file));
                                        }
                                      },
                                      child: const UploadWidget(),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 10.w,
                                ),
                                Stack(
                                  alignment: Util.getLang() != "ar"
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  children: [
                                    CustomTextFromField(
                                      hasBorder: true,
                                      borderWidth: 1,
                                      borderColor: DMUtil.getD2C(),
                                      labelText: '',
                                      height: 46,
                                      hintText: translate("company.licence"),
                                      radius: 10,
                                      onChanged: (val) {},
                                      onFieldSubmitted: (val) {},
                                      textEditingController:
                                          licenceTextEditingController,
                                      enabled: false,
                                      cursorColor: kPrimary,
                                      validator: () {},
                                      prefixIcon: null,
                                      obscureText: false,
                                      suffixIcon: null,
                                      isLabelError: false,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final res =
                                            await getImage(ctx: context);
                                        if (res == null) return;
                                        final file = await cropImage(res);
                                        if (file != null) {
                                          licenceTextEditingController.text =
                                              _getFileName(file);
                                          AuthBloc.get(context).add(
                                              UpdateNurseRegisterDataEvent(
                                                  license: file));
                                        }
                                      },
                                      child: const UploadWidget(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),
                                Stack(
                                  alignment: Util.getLang() != "ar"
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  children: [
                                    CustomTextFromField(
                                      hasBorder: true,
                                      borderWidth: 1,
                                      borderColor: DMUtil.getD2C(),
                                      labelText: '',
                                      height: 45,
                                      hintText: translate("nurse.certificate"),
                                      radius: 10,
                                      onChanged: (val) {},
                                      onFieldSubmitted: (val) {},
                                      textEditingController:
                                          certificateTextEditingController,
                                      cursorColor: kPrimary,
                                      enabled: false,
                                      validator: () {},
                                      prefixIcon: null,
                                      obscureText: false,
                                      suffixIcon: null,
                                      isLabelError: false,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final res =
                                            await getImage(ctx: context);
                                        if (res == null) return;
                                        final file = await cropImage(res);
                                        if (file != null) {
                                          certificateTextEditingController
                                              .text = _getFileName(file);
                                          AuthBloc.get(context).add(
                                              UpdateNurseRegisterDataEvent(
                                                  certificate: file));
                                        }
                                      },
                                      child: const UploadWidget(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),
                                Stack(
                                  alignment: Util.getLang() != "ar"
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  children: [
                                    CustomTextFromField(
                                      hasBorder: true,
                                      borderWidth: 1,
                                      borderColor: DMUtil.getD2C(),
                                      labelText: '',
                                      height: 45,
                                      hintText:
                                          translate("nurse.association_card"),
                                      radius: 10,
                                      onChanged: (val) {},
                                      onFieldSubmitted: (val) {},
                                      textEditingController:
                                          associateTextEditingController,
                                      cursorColor: kPrimary,
                                      enabled: false,
                                      validator: () {},
                                      prefixIcon: null,
                                      obscureText: false,
                                      suffixIcon: null,
                                      isLabelError: false,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final res =
                                            await getImage(ctx: context);
                                        if (res == null) return;
                                        final file = await cropImage(res);
                                        if (file != null) {
                                          associateTextEditingController.text =
                                              _getFileName(file);
                                          AuthBloc.get(context).add(
                                              UpdateNurseRegisterDataEvent(
                                                  associationCard: file));
                                        }
                                      },
                                      child: const UploadWidget(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),
                                if (bloc.isDoctor) ...[
                                  Stack(
                                    alignment: Util.getLang() != "ar"
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    children: [
                                      CustomTextFromField(
                                        hasBorder: true,
                                        borderWidth: 1,
                                        borderColor: DMUtil.getD2C(),
                                        labelText: '',
                                        height: 46,
                                        hintText:
                                            translate("nurse.related_job"),
                                        radius: 10,
                                        onChanged: (val) {},
                                        onFieldSubmitted: (val) {},
                                        textEditingController:
                                            relatedJobCardTextEditingController,
                                        enabled: false,
                                        cursorColor: kPrimary,
                                        validator: () {},
                                        prefixIcon: null,
                                        obscureText: false,
                                        suffixIcon: null,
                                        isLabelError: false,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          final res =
                                              await getImage(ctx: context);
                                          if (res == null) return;
                                          final file = await cropImage(res);
                                          if (file != null) {
                                            relatedJobCardTextEditingController
                                                .text = _getFileName(file);
                                            AuthBloc.get(context).add(
                                                UpdateNurseRegisterDataEvent(
                                                    relatedJobId: file));
                                          }
                                        },
                                        child: const UploadWidget(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.w,
                                  ),
                                ],
                              ],
                            );
                          }
                        },
                      ),
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

  _getFileName(File file) {
    String name = basename(file.path);
    return name;
  }

  validateForm({BuildContext? context, required AuthBloc bloc}) {
    if (phoneTextEditingController.text.isEmpty) return false;

    if (emailTextEditingController.text.isEmpty ||
        !emailTextEditingController.text.contains("@")) {
      if (context != null) {
        SnackBarBuilder.showFeedBackMessage(
            context, translate("toast.email_invalid"), Colors.red);
      }
      return false;
    }
    if (bloc.isNurse || bloc.isDoctor) {
      if (associateTextEditingController.text.isEmpty ||
          licenceTextEditingController.text.isEmpty ||
          certificateTextEditingController.text.isEmpty) {
        return false;
      }
      if (bloc.isDoctor) {
        // Specialty validation removed - will be set after login
        if (relatedJobCardTextEditingController.text.isEmpty) {
          return false;
        }
      }
    } else {
      if (relatedJobCardTextEditingController.text.isEmpty) return false;
    }
    if (firstNameTextEditingController.text.isNotEmpty &&
        passwordTextEditingController.text.isNotEmpty &&
        nurseIDTextEditingController.text.isNotEmpty) {
      return true;
    }
    return false;
  }
}
