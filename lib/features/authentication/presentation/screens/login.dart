// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_event.dart';
import 'package:icare/features/authentication/presentation/widgets/nice_to_meet_row.dart';
import 'package:icare/features/authentication/presentation/widgets/not_have_an_account.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/root_app/bloc/root_event.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';
import 'package:icare/features/root_app/screens/root_screen.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter_translate/flutter_translate.dart';

class LoginScreen extends StatelessWidget {
  final bool fromRegistration;
  const LoginScreen({super.key, this.fromRegistration = false});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneTextEditingController =
        TextEditingController();
    final TextEditingController passTextEditingController =
        TextEditingController();

    bool validateForm() {
      if (phoneTextEditingController.text.isEmpty) return false;
      if (passTextEditingController.text.isEmpty) return false;
      return true;
    }

    return Scaffold(
        backgroundColor: DMUtil.getWC(),
        body: BlocListener<AuthBloc, AuthState>(
          listenWhen: (context, state) =>
              state is LogInSuccessfullyState || state is LogInFailedState,
          listener: (ctx, state) {
            var bloc = AuthBloc.get(ctx);
            if (state is LogInSuccessfullyState &&
                state.response.isSuccess == true) {
              // User is verified and app is initialized (handled in AuthBloc)
              SnackBarBuilder.showFeedBackMessage(
                  context, translate("auth.login_success"), Colors.green);
              RootBloc.get(context).add(const ChangeIndex(index: 1, title: ""));
              Util.pushPageAndRemoveRoutes(const RootScreen(), context);
            } else if (state is LogInFailedState) {
              SnackBarBuilder.showFeedBackMessage(
                  context, bloc.resMsg, Colors.red);
            }
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                AppBarWithRadius(
                  enableBackIcon: Navigator.canPop(context),
                  switchLang: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppStyle.paddingFromH.w, vertical: 10),
                  child: Column(
                    children: [
                      const NiceToMeetRowWidget(),
                      SizedBox(
                        height: 20.w,
                      ),
                      // Show pending approval message if coming from registration
                      if (fromRegistration)
                        Container(
                          padding: EdgeInsets.all(16.w),
                          margin: EdgeInsets.only(bottom: 20.h),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.blue.shade200, width: 1.5),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue.shade700,
                                size: 24.w,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: CustomText(
                                  text: translate(
                                      "auth.pending_approval_message"),
                                  fontSize: AppStyle.small.sp,
                                  color: DMUtil.getPC(),
                                  fontWeight: FontWeight.w500,
                                  maxLine: 3,
                                ),
                              ),
                            ],
                          ),
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
                      const SizedBox(
                        height: 20,
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
                            textEditingController: passTextEditingController,
                            cursorColor: DMUtil.getPC(),
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
                        height: 40.w,
                      ),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (ctx, state) {
                          var autBloc = AuthBloc.get(ctx);
                          // Clean Arch: UI reacts to both login and initialization states
                          bool isLoading = state is LogInLoadingState ||
                              state is AuthInitializingState;
                          return CustomButton(
                            height: 45.h,
                            width: 200.w,
                            circular: 10,
                            widget: isLoading
                                ? SizedBox(
                                    height: 20.w,
                                    width: 20.w,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: translate("login.login"),
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
                            onPressed: isLoading
                                ? null
                                : () async {
                                    var phone =
                                        phoneTextEditingController.text.trim();
                                    var password = passTextEditingController
                                        .text
                                        .trim()
                                        .replaceAll('\u0000', '');
                                    if (validateForm()) {
                                      var data = {
                                        'phone': phone,
                                        'password': password
                                      };
                                      autBloc.add(LogInEvent(user: data));
                                    } else {
                                      SnackBarBuilder.showFeedBackMessage(
                                          context,
                                          translate("toast.field_empty"),
                                          Colors.red);
                                    }
                                  },
                          );
                        },
                      ),

                      SizedBox(
                        height: 20.w,
                      ),
                      const NotHaveAnAccountWidget(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ));
  }
}
