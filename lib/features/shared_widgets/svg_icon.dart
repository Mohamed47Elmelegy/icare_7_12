import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconWidget extends StatelessWidget {
  final String iconUrl;
  const SvgIconWidget({super.key, required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: DMUtil.getBCD(),
      radius: 25.h,
      child: iconUrl.contains("file:///") || iconUrl.isEmpty
          ? Image.asset(AppImages.logo)
          : SvgPicture.network(
              iconUrl,
              height: 29.h,
              colorFilter:
                  ColorFilter.mode(DMUtil.getBCIcon(), BlendMode.srcIn),
              placeholderBuilder: (context) => SizedBox(
                height: 29.h,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorBuilder: (context, error, stackTrace) => Image.asset(
                AppImages.logo,
                height: 29.h,
              ),
            ),
    );
  }
}
