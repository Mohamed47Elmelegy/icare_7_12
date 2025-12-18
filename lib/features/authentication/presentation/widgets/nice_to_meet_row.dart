import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/align_child_by_row.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class NiceToMeetRowWidget extends StatelessWidget {
  const NiceToMeetRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlignChildRow(
      isStart: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: translate("icare.nice_to_meet_you"),
            fontSize: AppStyle.small.sp,
            color: DMUtil.getText2(),
          ),
          CustomText(
            text: translate("icare.join"),
            color: DMUtil.getPC(),
            fontSize: AppStyle.average.sp + 2,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
