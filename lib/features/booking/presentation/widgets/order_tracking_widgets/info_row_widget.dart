import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class InfoRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const InfoRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          color: DMUtil.getD2C().withValues(alpha: 0.5),
          fontSize: AppStyle.verySmall.sp,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Expanded(
              child: CustomText(
                text: value,
                color: DMUtil.getDC(),
                fontSize: AppStyle.small.sp + 1,
                fontWeight: FontWeight.w600,
                maxLine: 1,
                isEllipsis: true,
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: 8.w),
              trailing!,
            ],
          ],
        ),
      ],
    );
  }
}
