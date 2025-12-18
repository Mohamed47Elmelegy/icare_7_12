import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class LocationKindWidget extends StatelessWidget {
  final VoidCallback fn;
  final String title;
  final String img;
  final bool selected;
  const LocationKindWidget(
      {super.key,
      required this.img,
      required this.title,
      required this.fn,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: fn,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: selected ? kPrimary : Colors.white,
          border: Border.all(width: 1, color: selected ? kPrimary : kText1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              img,
              height: 13.h,
              fit: BoxFit.contain,
              width: 20.w,
            ),
            CustomText(
              text: title,
              color: selected ? Colors.white : kText1,
              fontSize: AppStyle.verySmall.sp,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}
