import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgAssetIconWidget extends StatelessWidget {
  final String iconPath;
  final Color color;
  const SvgAssetIconWidget({super.key,required this.iconPath,this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      width: 20.w,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}



