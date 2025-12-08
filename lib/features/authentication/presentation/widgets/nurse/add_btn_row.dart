import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';

class AddRowWithTitle extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const AddRowWithTitle({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontWeight: FontWeight.w600,
          fontSize: AppStyle.small.sp,
        ),
        // InkWell(
        //   onTap: onTap,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       CustomText(
        //         text: translate("button.add"),
        //         fontWeight: FontWeight.w600,
        //         fontSize: AppStyle.small.sp-2,
        //       ),
        //       const SizedBox(width: 5,),
        //       Icon(Icons.add,size: 18.w,)
        //     ],
        //   ),
        // ),
        CustomButton(
          height: 35.h,
          width: 95.w,
          color: DMUtil.getPC2(),
          onPressed: onTap,
          circular: 10,
          widget: CustomText(
            text: translate("button.add"),
            fontWeight: FontWeight.w600,
            fontSize: AppStyle.small.sp - 2,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
