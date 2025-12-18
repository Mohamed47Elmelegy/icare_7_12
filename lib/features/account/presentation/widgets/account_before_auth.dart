import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/root_app/screens/welcome_screens/new_experience_screen.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AccountNotAuth extends StatelessWidget {
  const AccountNotAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 100,
          ),
          CustomText(
            text: translate("profile.welcome"),
            color: DMUtil.getDC(),
            fontWeight: FontWeight.w700,
            fontSize: AppStyle.large.sp,
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () => Util.pushPage(const NewExperienceScreen(), context),
            child: CustomText(
              text: translate("login.app_bar"),
              color: DMUtil.getPC(),
              fontSize: AppStyle.average.sp,
            ),
          ),
        ],
      ),
    );
  }
}
