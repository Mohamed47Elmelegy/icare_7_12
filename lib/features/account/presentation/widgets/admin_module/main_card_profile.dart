import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainProfileCard extends StatelessWidget {
  final String title;
  final String imgPath;
  final VoidCallback fn;
  const MainProfileCard(
      {super.key,
      required this.title,
      required this.imgPath,
      required this.fn});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: fn,
      child: Container(
        alignment: Alignment.center,
        width: 100.w,
        height: 115.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: DMUtil.getWC(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: title,
              fontSize: AppStyle.small.sp - 2,
              fontWeight: FontWeight.w600,
              color: DMUtil.getPC(),
              alignCenter: true,
              isEllipsis: true,
            ),
            SizedBox(
              height: 10.w,
            ),
            SvgPicture.asset(
              imgPath,
              width: 60.w,
              height: 50.w,
              fit: BoxFit.contain,
            )
          ],
        ),
      ),
    );
  }
}
