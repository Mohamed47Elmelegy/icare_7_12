import 'package:icare/core/strings/enum/user_enum.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/presentation/screens/nurse/create_nurse_account.dart';
import 'package:icare/features/authentication/presentation/screens/register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class NotHaveAnAccountWidget extends StatelessWidget {
  const NotHaveAnAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text:
        "${translate("login.dont_have_anaccount")}  ",
        children: [
          TextSpan(
            text: translate("signup.signup"),
            style: TextStyle(
              color: DMUtil.getPC(),
              fontWeight: FontWeight.bold,
              fontSize: AppStyle.verySmall.sp,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () =>  Util.getUserType()==UserEnum.NURSE.name.toLowerCase()?  Util.pushPage(const CreateNurseAccountScreen(), context) : Util.pushPage(const RegisterScreen(), context),
          )
        ],
        style: TextStyle(
          color: DMUtil.getD2C(),
          fontFamily: primaryFontReg,
          fontSize: AppStyle.verySmall.sp
        ),
      ),
    );
  }
}
