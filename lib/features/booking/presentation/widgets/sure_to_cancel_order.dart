import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class CancelOrderWidget extends StatelessWidget {
  const CancelOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
      width: 300.w,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomText(
              text: translate("order.sure_to_cancel"),
              color: Colors.black,
              fontSize: AppStyle.average.sp),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                  height: 30.h,
                  width: 100.w,
                  circular: 5,
                  widget: CustomText(
                      text: translate("button.ok"),
                      color: Colors.white,
                      fontSize: AppStyle.small.sp),
                  color: kPrimary,
                  onPressed: () => Navigator.pop(context, "cancel")),
              CustomButton(
                  height: 30.h,
                  width: 100.w,
                  circular: 5,
                  widget: CustomText(
                      text: translate("button.cancel"),
                      color: Colors.red,
                      fontSize: AppStyle.small.sp),
                  color: Colors.white,
                  sideWidth: 1,
                  sideColor: Colors.black45,
                  onPressed: () => Navigator.of(context).pop()),
            ],
          ),
        ],
      ),
    );
  }
}
