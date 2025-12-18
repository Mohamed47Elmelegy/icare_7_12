import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AssignedImageWidget extends StatelessWidget {
  final bool isSmall;
  const AssignedImageWidget({super.key, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          AppImages.assigned,
          height: isSmall ? 18.h : 42.h,
        ),
        CustomText(
          text: translate("order.assigned"),
          color: Colors.black,
          fontSize: isSmall ? AppStyle.verySmall.sp : AppStyle.average.sp,
          fontFamily: primaryFontBold,
        ),
      ],
    );
  }
}
