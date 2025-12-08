import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/view_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewAllRow extends StatelessWidget {
  final String title;
  final VoidCallback fn;
  const ViewAllRow({super.key,required this.title,required this.fn});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontWeight: FontWeight.w600,
          fontSize: AppStyle.large.sp-2.w,
        ),
        ViewAllWidget(fn: fn),
      ],
    );
  }
}
