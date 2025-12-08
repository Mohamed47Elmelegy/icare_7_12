import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/presentation/screens/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AlreadyHaveAnAccountWidget extends StatelessWidget {
  const AlreadyHaveAnAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: "${translate("signup.already_have_account")}  ",
          children: [
            TextSpan(
              text: translate("login.app_bar"),
              style: TextStyle(
                color: DMUtil.getText(),
                fontSize: AppStyle.small.sp,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Util.pushPage(const LoginScreen(), context),
            )
          ],
          style: TextStyle(
            color: DMUtil.getPC2(),
            fontFamily: primaryFontReg,
            fontSize: AppStyle.small.sp,
          ),
        ),
      ),
    );
  }
}
