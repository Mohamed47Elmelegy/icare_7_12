import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

/// Reusable column widget for displaying label-value pairs in booking details
class BookingInfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool isFullWidth;

  const BookingInfoColumn({
    super.key,
    required this.label,
    required this.value,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          color: DMUtil.getD2C().withOpacity(0.5),
          fontSize: AppStyle.verySmall.sp,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: value,
          color: DMUtil.getDC(),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          maxLine: isFullWidth ? 3 : 2,
        ),
      ],
    );
  }
}
