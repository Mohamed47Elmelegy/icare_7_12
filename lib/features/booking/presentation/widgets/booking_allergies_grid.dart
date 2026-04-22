import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

/// Widget for displaying patient allergies in a grid layout
class BookingAllergiesGrid extends StatelessWidget {
  final List<String> allergies;

  const BookingAllergiesGrid({super.key, required this.allergies});

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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Allergies",
            fontSize: AppStyle.average.sp,
            fontWeight: FontWeight.w600,
            color: DMUtil.getDC(),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: allergies.map((allergy) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.circle_outlined,
                    size: 12.w,
                    color: DMUtil.getPC(),
                  ),
                  SizedBox(width: 6.w),
                  CustomText(
                    text: allergy,
                    fontSize: AppStyle.small.sp,
                    color: DMUtil.getD2C(),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
