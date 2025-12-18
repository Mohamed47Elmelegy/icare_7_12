import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class EmptyDataWidget extends StatelessWidget {
  final String? txt;
  const EmptyDataWidget({super.key, this.txt});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomText(
            text: txt ?? translate("toast.empty"),
            color: Colors.black38,
            fontSize: AppStyle.small.sp),
      ),
    );
  }
}
