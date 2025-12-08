import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/shared_widgets/custom_dialogs.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class DeleteAccountWidget extends StatelessWidget {
  const DeleteAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> CustomDialogs.deleteAccount(context),
      child: CustomText(
        text: translate("profile.delete_my_account"),
        fontSize: AppStyle.average.sp - 3,
        color: DMUtil.getRED(),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
