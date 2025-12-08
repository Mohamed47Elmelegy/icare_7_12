import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/root_app/screens/welcome_screens/welcome_screen.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DMUtil.getWC(),
      body: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: SvgPicture.asset(AppImages.logoSvg),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 40.w),
              child: CustomButton(
                  height: 40.w,
                  width: 240.w,
                  withShadow: true,
                  widget: CustomText(
                    text: translate("app_bar.get_started"),
                    fontSize: AppStyle.average.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  color: DMUtil.getPC(),
                  onPressed: ()=> Util.pushPage(const WelcomeScreen(), context)
              ),
            ),


          ],
        ),
      )
    );
  }
}
