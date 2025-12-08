import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ThanksOrderWidget extends StatelessWidget {
  const ThanksOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      width: 400.w,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(AppImages.thanksOrder,height: 140.h,fit: BoxFit.contain,),

          const SizedBox(height: 5,),
          CustomText(
              text: translate("order.thanks_order"),
              color: DMUtil.getD2C(),
              fontSize: AppStyle.average.sp,
              alignCenter: true,
              maxLine: 4,
          ),

          const SizedBox(height: 2,),
          CircularProgressIndicator(
            color: DMUtil.getGreen(),
          ),
        
        ],
      ),
    );
  }
}
