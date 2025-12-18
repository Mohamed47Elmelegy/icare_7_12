import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RowWithTwoTitle extends StatelessWidget {
  final String title1;
  final String title2;
  const RowWithTwoTitle(
      {super.key, required this.title1, required this.title2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.w),
      child: Row(
        children: [
          SizedBox(
            width: 60.w,
            child: CustomText(
              text: title1,
              fontSize: AppStyle.verySmall.sp,
              color: DMUtil.getD2C(),
            ),
          ),
          CustomText(
            text: title2,
            fontSize: AppStyle.verySmall.sp,
            color: DMUtil.getD2C(),
          ),
        ],
      ),
    );
  }
}
