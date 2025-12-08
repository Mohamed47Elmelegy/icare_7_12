import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LikeIcon extends StatelessWidget {
  const LikeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: DMUtil.getBackGround(),
      radius: 19.w,
      child: Image.asset(AppImages.like,width: 20.w,),
    );
  }
}
