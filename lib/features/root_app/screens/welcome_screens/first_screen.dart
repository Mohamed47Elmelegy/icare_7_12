import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: translate("icare.welcome_f"),
          fontSize: AppStyle.large.sp,
          color: DMUtil.getText(),
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          height: 10,
        ),
        CustomText(
          text: translate("icare.welcome_f"),
          fontSize: AppStyle.average.sp - 2,
          color: DMUtil.getPC2(),
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          height: 40,
        ),
        SvgPicture.asset(
          AppImages.welcomeFirst,
          height: 250.h,
        ),
      ],
    );
  }
}
