import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemLineDrawer extends StatelessWidget {
  final String title;
  final VoidCallback fn;
  final Widget? icon;
  const ItemLineDrawer({super.key,required this.title,required this.fn,this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: fn,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.w,horizontal: 8.w),
        child: Row(
          children: [
            icon ?? const SizedBox.shrink(),
            const SizedBox(width: 10,),
            CustomText(
              text: title,
              color:DMUtil.getDC(),
              fontWeight: FontWeight.w600,
              fontSize: AppStyle.small.sp,
            ),
          ],
        ),
      )
    );
  }
}