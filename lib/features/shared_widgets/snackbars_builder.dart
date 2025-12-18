import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SnackBarBuilder {
  static showFeedBackMessage(BuildContext context, String message, Color color,
      {bool addBehaviour = true,
      bool isMarginBottom = false,
      double margin = 132}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
              fontSize: AppStyle.small.sp - 1, fontFamily: primaryFontReg),
        ),
        backgroundColor: color,
        margin: isMarginBottom
            ? EdgeInsets.only(bottom: margin.w)
            : EdgeInsets.zero,
        padding: EdgeInsets.all(4.w),
        behavior: addBehaviour ? SnackBarBehavior.floating : null,
        action: SnackBarAction(
            label: 'Dismiss',
            textColor: DMUtil.getWC(),
            onPressed: () => ScaffoldMessenger.of(context).clearSnackBars),
      ),
    );
  }
}
