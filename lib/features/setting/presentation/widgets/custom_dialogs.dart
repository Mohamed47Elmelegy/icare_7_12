
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/shared_widgets/align_child_by_row.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';


class CustomSettingDialogs{
  static rating(BuildContext context){
    return showDialog(
        context: context,
        builder: (context){
          return  AlertDialog(
            titlePadding: const EdgeInsets.all(5),
            contentPadding: EdgeInsets.zero,
            title: AlignChildRow(
              child: GestureDetector(
                onTap: ()=> Navigator.of(context).pop(),
                child: const Icon(Icons.close,color: Colors.black45),
              )
            ),
            content: SizedBox(
              height: 200.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.rate_review_outlined,size: 35,),
                  const SizedBox(height: 15),
                  CustomText(
                    text: translate("activity_setting.Rating_FeedBack"),
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: AppStyle.small.sp,
                  ),
                  const SizedBox(height: 15),
                  CustomText(
                    text: translate("activity_setting.would_leave_comment"),
                    color: Colors.black54,
                    alignCenter: true,
                    fontSize: AppStyle.verySmall.sp,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    height: 30.h,
                    width: 230.w,
                    circular: 0,
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star_border,color: Colors.white,size: 20),
                        const SizedBox(width: 5,),
                        CustomText(
                          text: translate("activity_setting.rating").toUpperCase(),
                          color: Colors.white,
                          fontSize: AppStyle.small.sp,
                        ),
                      ],
                    ),
                    color: Colors.black,
                    onPressed:()=> Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    height: 30.h,
                    width: 230.w,
                    circular: 0,
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chat_outlined,color: Colors.black,size: 20),
                        const SizedBox(width: 5,),
                        CustomText(
                          text:translate("activity_setting.feedback").toUpperCase(),
                          color: Colors.black,
                          fontSize: AppStyle.small.sp,
                        ),
                      ],
                    ),
                    sideWidth: 1,
                    sideColor: Colors.black54,
                    color: Colors.white,
                    onPressed:()=> Navigator.of(context).pop(),
                  ),
                ],
              ),
            )
          );
        }
    );
  }
}
