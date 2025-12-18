import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/authentication/presentation/screens/login.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_event.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';
import 'package:icare/features/shared_widgets/align_child_by_row.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ResetPassword extends StatelessWidget {
  final bool goToLogin;
  const ResetPassword({super.key, this.goToLogin = true});
  static final TextEditingController passTextEditingController =
      TextEditingController();
  static final TextEditingController passEnsureTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DMUtil.getWC(),
        appBar: GlobalAppBar(
          justLogo: false,
          leadingIcon: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BackArrowButton(
                color: DMUtil.getPC(),
              ),
              const SizedBox(
                width: 5,
              ),
              CustomText(
                text: translate("signup.reset_password"),
                fontSize: AppStyle.large.sp,
                fontFamily: primaryFontSemiBold,
                color: DMUtil.getDC(),
                alignCenter: true,
              ),
            ],
          ),
          title: '',
        ),
        body: BlocListener<AccountBloc, AccountState>(
          listenWhen: (context, state) => state is ChangeUserPasswordState,
          listener: (ctx, state) {
            if (state is ChangeUserPasswordState) {
              if (state.response.isSuccess == true) {
                // passTextEditingController.text = "";
                if (goToLogin) {
                  Util.pushPageAndRemoveRoutes(const LoginScreen(), context);
                }
                SnackBarBuilder.showFeedBackMessage(
                    context, state.response.msg.toString(), Colors.green);
              } else if (state.response.isFailed == true) {
                SnackBarBuilder.showFeedBackMessage(
                    context, state.response.msg.toString(), Colors.red);
              }
            }
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: AppStyle.paddingFromH.w,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: AppStyle.paddingFromTop.h,
                ),
                AlignChildRow(
                  isStart: true,
                  child: CustomText(
                    text: translate("login.enter_new_password"),
                    color: DMUtil.getDC(),
                    fontSize: AppStyle.average.sp,
                    fontFamily: primaryFontSemiBold,
                  ),
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
                        height: 50,
                        radius: 10,
                        hintText: translate("login.your_password"),
                        textEditingController: passTextEditingController,
                        cursorColor: kPrimary,
                        validator: () {},
                        prefixIcon: null,
                        obscureText: !showPassword,
                        suffixIcon: IconButton(
                          onPressed: () => ctx
                              .read<AuthBloc>()
                              .add(const ChangePasswordEvent()),
                          icon: Icon(
                            showPassword == true
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash,
                            color: DMUtil.getDC(),
                          ),
                        ),
                        isLabelError: false);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (ctx, state) {
                    var bloc = AuthBloc.get(ctx);
                    bool showPassword = bloc.showPassword;
                    return CustomTextFromField(
                        hintText: translate("login.re_type_password"),
                        hasBorder: true,
                        borderWidth: 1,
                        borderColor: DMUtil.getD2C(),
                        labelText: '',
                        height: 50,
                        radius: 10,
                        textEditingController: passEnsureTextEditingController,
                        cursorColor: kPrimary,
                        validator: () {},
                        prefixIcon: null,
                        obscureText: !showPassword,
                        suffixIcon: IconButton(
                          onPressed: () => ctx
                              .read<AuthBloc>()
                              .add(const ChangePasswordEvent()),
                          icon: Icon(
                            showPassword == true
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash,
                            color: DMUtil.getDC(),
                          ),
                        ),
                        isLabelError: false);
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocBuilder<AccountBloc, AccountState>(
                  builder: (ctx, state) {
                    var bloc = AccountBloc.get(ctx);
                    return CustomButton(
                      height: 40.h,
                      width: double.infinity,
                      circular: 15,
                      widget: state is ChangeUserPasswordState &&
                              state.response.isLoad == true
                          ? CircularProgressIndicator(
                              color: DMUtil.getWC(),
                            )
                          : CustomText(
                              text: translate("button.confirm"),
                              color: DMUtil.getWC(),
                              fontSize: AppStyle.average.sp,
                              alignCenter: true,
                            ),
                      color: DMUtil.getPC(),
                      onPressed: () {
                        if (!checkIfTheSame()) {
                          return SnackBarBuilder.showFeedBackMessage(
                              context,
                              translate("signup.confirm_password_error"),
                              Colors.red);
                        }
                        if (validateForm()) {
                          bloc.add(ChangeUserPasswordEvent(data: {
                            "id": Util.getUserID(),
                            "password": passTextEditingController.text.trim(),
                          }));
                        } else {
                          SnackBarBuilder.showFeedBackMessage(context,
                              translate("toast.field_empty"), Colors.red);
                        }
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ));
  }

  checkIfTheSame() {
    return passTextEditingController.text.trim() ==
        passEnsureTextEditingController.text.trim();
  }

  validateForm() {
    if (passTextEditingController.text.trim().isNotEmpty &&
        passEnsureTextEditingController.text.trim().isNotEmpty) {
      return true;
    }
    return false;
  }
}
