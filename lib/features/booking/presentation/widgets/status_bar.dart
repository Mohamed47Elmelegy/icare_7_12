import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class StatusBarWidget extends StatelessWidget {
  final bool isEnabled;
  final String txt;
  const StatusBarWidget(
      {super.key, required this.txt, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 3.h,
          width: 100.w,
          color: isEnabled ? Colors.green : kText1,
        ),
        CustomText(
          text: txt,
          color: kText1,
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}
