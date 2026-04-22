import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class ViewAllWidget extends StatelessWidget {
  final VoidCallback fn;
  const ViewAllWidget({super.key, required this.fn});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: fn,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: DMUtil.getPC().withValues(alpha: 0.4)),
        ),
        child: CustomText(
          text: translate("home.view_all"),
          fontSize: AppStyle.small.sp - 1,
          fontWeight: FontWeight.w600,
          color: DMUtil.getPC(),
        ),
      ),
    );
  }
}
