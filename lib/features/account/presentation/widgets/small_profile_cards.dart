import 'package:flutter/material.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmallProfileCards extends StatelessWidget {
  final String title;
  final String subTitle;
  const SmallProfileCards(
      {super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: DMUtil.getWC()),
      child: Column(
        children: [
          CustomText(
            text: title,
            fontSize: AppStyle.verySmall.sp,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            height: 3,
          ),
          CustomText(
            text: subTitle,
            fontSize: AppStyle.verySmall.sp - 3,
            fontWeight: FontWeight.w600,
            color: DMUtil.getD2C(),
          ),
        ],
      ),
    );
  }
}
