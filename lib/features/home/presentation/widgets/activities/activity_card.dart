import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  AppImages.brain,
                  width: 40.w,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Doctors",
                      color: DMUtil.getText(),
                      fontSize: AppStyle.small.sp - 1,
                    ),
                    CustomText(
                      text: "Brain Checkout",
                      color: DMUtil.getText(),
                      fontSize: AppStyle.average.sp,
                    ),
                    CustomText(
                      text: "Have an appointment today",
                      color: DMUtil.getText(),
                      fontSize: AppStyle.small.sp - 1,
                    ),
                  ],
                ),
              ],
            ),
            CustomButton(
              height: 22.h,
              width: 60.w,
              widget: CustomText(
                text: translate("button.view"),
                fontSize: AppStyle.small.sp,
                color: DMUtil.getWC(),
              ),
              color: DMUtil.getButtonOrangeColor(),
              onPressed: () {},
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
