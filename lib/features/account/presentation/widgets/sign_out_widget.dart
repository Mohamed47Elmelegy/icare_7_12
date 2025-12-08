import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/shared_widgets/custom_dialogs.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class SignOutWidget extends StatelessWidget {
  const SignOutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> CustomDialogs.signOut(context),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            children: [
              Icon(Icons.logout,color: DMUtil.getD2C(),size: 20.w,),
              const SizedBox(width: 10,),
              CustomText(
                text: translate("activity_setting.sign_out"),
                color: DMUtil.getD2C(),
                fontSize: AppStyle.average.sp,
              ),
            ],
          )
      ),
    );
  }
}
