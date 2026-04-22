import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/setting/presentation/widgets/small_widgets.dart';
import 'package:icare/features/shared_widgets/custom_dialogs.dart';

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingLineOption(
      title: translate("profile.delete_account"),
      onTap: () {
        CustomDialogs.deleteAccount(context);
      },
      widget: Icon(Icons.delete_forever, color: DMUtil.getRED(), size: 23.w),
    );
  }
}
