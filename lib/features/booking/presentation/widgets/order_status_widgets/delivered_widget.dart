import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/features/shared_widgets/custom_dialogs.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class DeliveredImageWidget extends StatelessWidget {
  final bool isSmall;
  final String? img;
  const DeliveredImageWidget({super.key, this.isSmall = false, this.img});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          AppImages.delivered,
          height: isSmall ? 18.h : 42.h,
        ),
        CustomText(
          text: translate("order.delivered"),
          color: Colors.black,
          fontSize: isSmall ? AppStyle.verySmall.sp : AppStyle.average.sp,
          fontFamily: primaryFontBold,
        ),
        if (img != null && img != "") ...[
          CustomText(
            text: translate("order.file"),
            color: Colors.black,
            fontSize: isSmall ? AppStyle.verySmall.sp : AppStyle.average.sp,
            fontFamily: primaryFontBold,
          ),
          InkWell(
            onTap: () => CustomDialogs.viewImage(context, img!),
            child: Image.network(
              img!,
              width: 60.w,
              height: 35.h,
              fit: BoxFit.fill,
            ),
          )
        ],
      ],
    );
  }
}
