import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/root_app/screens/welcome_screens/new_experience_screen.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';

class TurnOnNotificationScreen extends StatelessWidget {
  const TurnOnNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        child: Column(
          children: [
            SizedBox(height: 50.h,),
            Expanded(
              child: SvgPicture.asset(
                AppImages.turnOnNotification,
                height: 500.h,
              ),
            ),

            CustomButton(
                height: 40.w,
                width: 240.w,
                withShadow: true,
                widget: CustomText(
                  text: translate("button.next"),
                  fontSize: AppStyle.average.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                color: DMUtil.getPC(),
                onPressed: ()=> Util.pushPage(const NewExperienceScreen(), context)
            ),
            SizedBox(height: 50.h,),

          ],
        ),
      )
    );
  }
}
