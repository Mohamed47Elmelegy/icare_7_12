import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class UploadWidget extends StatelessWidget {
  const UploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.w,
      child: Row(
        children: [
          Icon(Icons.upload,color: DMUtil.getRED(),size: 18.w,),
          CustomText(
            text: translate("button.upload"),
            color: DMUtil.getRED(),
            textDecoration: TextDecoration.underline,
            fontSize: AppStyle.small.sp-2,
          ),
        ],
      ),
    );
  }
}
