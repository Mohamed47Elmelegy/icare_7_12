import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoRow extends StatelessWidget {
  final IconData iconData;
  final String value;
  const InfoRow({super.key, required this.iconData, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            iconData,
            size: 18.w,
            color: DMUtil.getD2C(),
          ),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
            width: 250.w,
            child: CustomText(
              text: value,
              fontSize: AppStyle.small.sp,
              color: DMUtil.getD2C(),
              maxLine: 1,
              isEllipsis: true,
            ),
          )
        ],
      ),
    );
  }
}
