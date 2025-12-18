import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/features/shared_widgets/logo_widget.dart';

class LoginWelcomeWidget extends StatelessWidget {
  const LoginWelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoWidget(
              width: 150.w,
              fit: BoxFit.contain,
              height: 70.h,
            ),
            // const SizedBox(height: 20,),
            // CustomText(
            //   text: translate("login.app_bar"),
            //   color: kText1,
            //   fontWeight: FontWeight.w700,
            //   fontSize: AppStyle.large.sp,
            // ),
          ],
        ));
  }
}
