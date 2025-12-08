import 'package:flutter/material.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TapWidget extends StatelessWidget {
  final String title;
  final int index;
  final bool selected;
  final double width;
  final VoidCallback fn;
  const TapWidget({super.key,required this.title,required this.index,required this.selected,this.width = 100,required this.fn});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: fn,
        child: Container(
          width: width.w,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            gradient: selected? const LinearGradient(
                colors: [
                  Color(0xff329D9C),
                  Color(0xff7BE495),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight
            ):null,
          ),
          child: CustomText(
            text: title,
            fontSize: AppStyle.small.sp-1,
            color: selected?DMUtil.getWC():kPrimary,
          ),
        )
    );
  }
}