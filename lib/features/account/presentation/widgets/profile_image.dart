import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CircleAvatar(
          radius: 42.w,
          backgroundColor: Colors.transparent,
          backgroundImage: const AssetImage(AppImages.logo),
        ),
        Container(
          width: 100.w,
          height: 23.h,
          color: kWhite.withValues(alpha: 0.8),
          child: CustomText(
            text: translate("profile.edit_photo"),
            fontSize: AppStyle.verySmall.sp + 2,
            fontFamily: primaryFontBold,
            color: Colors.black,
            alignCenter: true,
          ),
        )
      ],
    );
  }
}
