import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

/// Widget for displaying booking description
class BookingDescription extends StatelessWidget {
  final String desc;

  const BookingDescription({super.key, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: DMUtil.getWC(),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Description",
            fontSize: AppStyle.average.sp,
            fontWeight: FontWeight.w600,
            color: DMUtil.getDC(),
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: desc.trim(),
            color: DMUtil.getD2C().withOpacity(0.8),
            fontSize: AppStyle.small.sp,
            maxLine: 10,
          ),
        ],
      ),
    );
  }
}
