import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';

class CircleProfileImage extends StatelessWidget {
  const CircleProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30.w,
          backgroundImage: const AssetImage(AppImages.avatar,),
        ),
        CircleGreenMark(size: 7,color: DMUtil.getGreen2(),),
      ],
    );
  }
}
