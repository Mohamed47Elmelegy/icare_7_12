import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icare/core/strings/app_images.dart';

class LogoWidget extends StatelessWidget {
  final double width;
  final double height;
  final BoxFit fit;
  final bool isWhite;
  const LogoWidget(
      {super.key,
      this.height = 30,
      this.width = double.infinity,
      this.fit = BoxFit.fill,
      this.isWhite = false});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      isWhite ? AppImages.logoWhite : AppImages.logo,
      height: height.h,
      width: width.w,
      fit: fit,
    );
  }
}
