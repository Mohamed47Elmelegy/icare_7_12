import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/presentation/screens/reset_password.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class SecureInfo extends StatelessWidget {
  const SecureInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DMUtil.getWC(),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomText(
            text: translate("profile.secure_info"),
            color: DMUtil.getD2C(),
            fontWeight: FontWeight.w600,
            fontSize: AppStyle.average.sp + 1,
          ),
          const SizedBox(
            height: 15,
          ),
          CustomText(
            text: translate("signup.password"),
            color: DMUtil.getDC(),
            fontSize: AppStyle.average.sp,
          ),
          const SizedBox(
            height: 5,
          ),
          CustomText(
            text: "************",
            color: DMUtil.getDC(),
            fontSize: AppStyle.veryLarge.sp + 3,
            letterSpace: 2,
          ),
          InkWell(
            onTap: () => Util.pushPage(
                const ResetPassword(
                  goToLogin: false,
                ),
                context),
            child: CustomText(
              text: translate("login.change_pass"),
              color: DMUtil.getPC(),
              fontWeight: FontWeight.w600,
              textDecoration: TextDecoration.underline,
              fontSize: AppStyle.small.sp - 1,
            ),
          ),
        ],
      ),
    );
  }
}
