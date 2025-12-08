import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/strings/constant.dart';
import 'package:icare/core/strings/enum/user_enum.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/presentation/screens/login.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';

class NewExperienceScreen extends StatelessWidget {
  const NewExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 50.w, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: translate("icare.nice_to_meet_you"),
            fontSize: AppStyle.small.sp,
            color: DMUtil.getText2(),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomText(
            text: translate("icare.new_experience"),
            fontSize: AppStyle.large.sp,
            color: DMUtil.getText2(),
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            height: 40,
          ),
          Align(
              child: Column(
            children: [
              SvgPicture.asset(
                AppImages.welcomeDelivery,
                height: 300.h,
              ),
              SizedBox(
                height: 60.w + 30.h,
              ),
              CustomButton(
                height: 40.w,
                width: 240.w,
                withShadow: true,
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: translate("login.sign_in_as_customer"),
                      fontSize: AppStyle.small.sp - 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.arrow_forward_outlined,
                      size: 20.w,
                      color: kWhite,
                    ),
                  ],
                ),
                color: DMUtil.getPC(),
                onPressed: () {
                  SharedPref().setPreferencesString(
                      Constants.userType, UserEnum.CUSTOMER.name);
                  Util.pushPage(const LoginScreen(), context);
                },
              ),
              SizedBox(
                height: 20.w,
              ),
              CustomButton(
                height: 40.w,
                width: 240.w,
                withShadow: true,
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: translate("login.sign_in_as_nurse_or_doctor"),
                      fontSize: AppStyle.small.sp - 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.arrow_forward_outlined,
                      size: 20.w,
                      color: kWhite,
                    ),
                  ],
                ),
                color: DMUtil.getPcSc(),
                onPressed: () {
                  SharedPref().setPreferencesString(
                      Constants.userType, UserEnum.NURSE.name);
                  Util.pushPage(const LoginScreen(), context);
                },
              ),
            ],
          )),
        ],
      ),
    ));
  }
}
