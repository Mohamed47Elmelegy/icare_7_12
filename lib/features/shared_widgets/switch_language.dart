import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:flutter/material.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwitchLanguageWidget extends StatelessWidget {
  final bool isRegisterNurse;
  const SwitchLanguageWidget({super.key,this.isRegisterNurse = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: ()=> Util.changeLang(ctx: context,isLogin: true,isRegisterNurse: isRegisterNurse,lang: "ar"),
          child: CustomText(
            text: "عربي",
            fontSize: AppStyle.average.sp,
            color: Util.getLang()=="ar"?DMUtil.getWC():DMUtil.getText2(),
          ),
        ),
        TextButton(
          onPressed: ()=> Util.changeLang(ctx: context,isLogin: true,lang: "en_US"),
          child: CustomText(
            text: "English",
            fontSize: AppStyle.average.sp,
            color: Util.getLang()!="ar"?DMUtil.getWC():DMUtil.getText2(),
          ),
        ),
      ],
    );
  }
}
