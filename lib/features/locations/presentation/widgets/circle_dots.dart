import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleDotsWidget extends StatelessWidget {
  final bool isEnabled;
  final bool isOpacity;
  const CircleDotsWidget({super.key,this.isEnabled = false,this.isOpacity = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 18.w,
        width: 18.w,
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          border: Border.all(width: 1,color: isOpacity? DMUtil.getRED().withOpacity(0.5):DMUtil.getD2C()),
          borderRadius: const BorderRadius.all(Radius.circular(25)),
        ),
        child: CircleAvatar(
          radius: 18.w,
          backgroundColor: isOpacity && !isEnabled? DMUtil.getRED().withOpacity(0.5) : (isEnabled?DMUtil.getRED():DMUtil.getWC()),
        )
    );
  }
}
