import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';

class BookingWelcomeSection extends StatelessWidget {
  const BookingWelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Hi Patient",
              fontSize: AppStyle.average.sp,
              color: DMUtil.getD2C(),
            ),
            CustomText(
              text: translate("toast.welcome_back"),
              color: DMUtil.getDC(),
              fontSize: AppStyle.average.sp + 2,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        SvgPicture.asset(
          AppImages.newBookingIcon,
        ),
      ],
    );
  }
}
