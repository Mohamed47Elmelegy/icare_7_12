import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class LocationsEmpty extends StatelessWidget {
  const LocationsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          Image.asset(
            AppImages.logo,
            height: 30.h,
            fit: BoxFit.cover,
          ),
          Image.asset(
            AppImages.logo,
            height: 120.h,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomText(
              text: translate("location.empty_locations"),
              color: kPrimary,
              fontWeight: FontWeight.w700,
              fontSize: AppStyle.average.sp),
          CustomText(
              text: translate("location.add_current_location"),
              color: kPrimary,
              fontWeight: FontWeight.w500,
              fontSize: AppStyle.small.sp),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
