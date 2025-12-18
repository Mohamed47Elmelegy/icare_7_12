// ignore_for_file: use_build_context_synchronously

import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';
import 'package:icare/features/authentication/presentation/screens/verification_code.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});
  static final TextEditingController phoneTextEditingController =
      TextEditingController();
  static final TextEditingController passTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppBarWithRadius(
              enableBackIcon: true,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w),
              child: Column(
                children: [
                  CustomText(
                    text: translate("signup.reset_password"),
                    color: DMUtil.getDC(),
                    fontSize: AppStyle.large.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 250.w,
                    child: CustomText(
                      text: translate("login.forget_pass_msg"),
                      color: DMUtil.getDC(),
                      fontSize: AppStyle.average.sp,
                      maxLine: 2,
                      alignCenter: true,
                    ),
                  ),
                  SizedBox(
                    height: 40.w,
                  ),
                  IntlPhoneField(
                    controller: phoneTextEditingController,
                    decoration: InputDecoration(
                      labelText: translate("signup.phone"),
                      labelStyle: TextStyle(color: DMUtil.getD2C()),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(width: 1, color: DMUtil.getOpacity()),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(width: 1, color: DMUtil.getOpacity()),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: DMUtil.getOpacity()),
                      ),
                    ),
                    initialCountryCode: 'EG',
                    onChanged: (phone) {},
                  ),
                  SizedBox(
                    height: 20.w,
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (ctx, state) {
                      // var bloc = AuthBloc.get(ctx);
                      // FetchStates state = AuthBloc.get(context).states;
                      // if(state==FetchStates.LOADING)return const Center(child: CircularProgressIndicator(color: kPrimary,),);
                      return MaterialButton(
                        onPressed: () async {
                          String val = phoneTextEditingController.text.trim();
                          if (val.isNotEmpty) {
                            // if(await SmsApi.sendOtp(provider: email,isEmail: true)){
                            Util.pushPage(
                                const PinCodeVerificationScreen(
                                  data: {"phone": "23423432432"},
                                  isRegister: false,
                                ),
                                context);
                            // }
                          } else {
                            SnackBarBuilder.showFeedBackMessage(context,
                                translate("toast.field_empty"), Colors.red);
                          }
                        },
                        minWidth: 200.w,
                        height: 40.h,
                        color: DMUtil.getPC(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CustomText(
                          text: translate("button.send"),
                          color: Colors.white,
                          fontSize: AppStyle.average.sp,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
