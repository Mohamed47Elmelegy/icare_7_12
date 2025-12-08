
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class SureToDeleteWidget extends StatelessWidget {
  const SureToDeleteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.h,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomText(
              text: translate("map.sure_to_delete"),
              color: Colors.black,
              fontSize: AppStyle.small.sp,
              fontWeight: FontWeight.w500,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                  height: 30.h,
                  width: 100.w,
                  circular: 5,
                  widget: CustomText(
                      text: translate("button.ok").toUpperCase(),
                      color: Colors.white,
                      fontSize: AppStyle.small.sp),
                  color: kPrimary,
                  onPressed: ()=>Navigator.pop(context,'ok')),
              CustomButton(
                  height: 30.h,
                  width: 100.w,
                  circular: 5,
                  widget: CustomText(
                      text: translate("button.cancel").toUpperCase(),
                      color: Colors.red,
                      fontSize: AppStyle.small.sp),
                  color: Colors.white,
                  sideWidth: 1,
                  sideColor: Colors.black45,
                  onPressed: ()=>Navigator.of(context).pop()),

            ],
          ),
        ],
      ),
    );
  }
}
