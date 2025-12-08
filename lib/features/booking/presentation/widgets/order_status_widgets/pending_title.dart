import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class PendingTitleWidget extends StatelessWidget {
  final bool isSmall;
  const PendingTitleWidget({super.key,this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.alarm,size: isSmall?20.w:40.w,),
        CustomText(
          text: translate("order.pending"),
          color: Colors.black,
          fontSize: isSmall? AppStyle.verySmall.sp : AppStyle.average.sp,
          fontFamily: primaryFontBold,
        ),
      ],
    );
  }
}
