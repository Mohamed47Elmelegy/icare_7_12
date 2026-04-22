import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class SettingLineOption extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Widget? widget;
  const SettingLineOption(
      {super.key, required this.title, this.onTap, this.widget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.w),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          // border: Border.all(width: 0.6,color: DMUtil.getBCC())
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: title,
              color: DMUtil.getD2C().withValues(alpha: 0.9),
              fontSize: AppStyle.average.sp - 1.w,
              fontWeight: FontWeight.w600,
            ),
            widget ??
                Icon(Icons.arrow_forward_ios,
                    color: DMUtil.getDC(), size: 17.w),
          ],
        ),
      ),
    );
  }
}
