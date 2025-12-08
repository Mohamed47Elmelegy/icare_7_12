
import 'package:icare/core/styles/my_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class SureToSubmitWidget extends StatelessWidget {
  const SureToSubmitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 150.h,
      width: 300.w,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomText(
              text: translate("toast.sure_to_submit"),
              color: Colors.black,
              fontSize: AppStyle.average.sp,
              fontFamily: primaryFontBold,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                  height: 30.h,
                  width: 100.w,
                  circular: 5,
                  widget: CustomText(
                      text: translate("button.yes"),
                      color: Colors.white,
                      fontFamily: primaryFontBold,
                      fontSize: AppStyle.average.sp),
                  color: Colors.black,
                  onPressed: ()=> Navigator.pop(context,true)),
              CustomButton(
                  height: 30.h,
                  width: 100.w,
                  circular: 5,
                  widget: CustomText(
                      text: translate("button.no"),
                      color: Colors.red,
                      fontFamily: primaryFontBold,
                      fontSize: AppStyle.average.sp),
                  color: Colors.white,
                  sideWidth: 1,
                  sideColor: Colors.black45,
                  onPressed: ()=>Navigator.pop(context,false)),

            ],
          ),
        ],
      ),
    );
  }
}
