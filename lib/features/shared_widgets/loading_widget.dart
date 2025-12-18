import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/strings/app_images.dart';

class LoadingWidget extends StatelessWidget {
  final double? height;
  final double? width;
  const LoadingWidget({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.loadingGif,
      fit: BoxFit.fill,
      width: width ?? double.infinity,
      height: height ?? 200.h,
    );
  }
}
