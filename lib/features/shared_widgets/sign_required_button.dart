import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/presentation/screens/login.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class SignRequiredButtons extends StatelessWidget {
  const SignRequiredButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: CustomButton(
          height: 30.h,
          width: 80.w,
          circular: 6,
          widget: CustomText(
              text: "Sign IN".toUpperCase(),
              color: Colors.white,
              fontSize: AppStyle.verySmall.sp),
          color: kPrimary,
          onPressed: () => Util.pushPage(const LoginScreen(), context)),
    );
  }
}
