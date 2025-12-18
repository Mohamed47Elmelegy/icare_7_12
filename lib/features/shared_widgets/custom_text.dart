import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:flutter/material.dart';
import 'package:icare/core/styles/my_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final bool? alignCenter;
  final bool? isEllipsis;
  final double? wordSpace;
  final double? letterSpace;
  final int? maxLine;
  const CustomText({
    super.key,
    required this.text,
    this.color,
    required this.fontSize,
    this.fontFamily,
    this.fontWeight,
    this.textDecoration,
    this.alignCenter,
    this.isEllipsis = false,
    this.wordSpace = 0,
    this.letterSpace = 0,
    this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          decoration: textDecoration ?? TextDecoration.none,
          color: color ?? DMUtil.getDC(),
          fontSize: fontSize - 1,
          fontFamily: primaryFontReg,
          fontWeight: FontWeight.w600,
          letterSpacing: letterSpace,
          wordSpacing: wordSpace),
      overflow: isEllipsis == true ? TextOverflow.ellipsis : null,
      textAlign: alignCenter == true ? TextAlign.center : null,
      maxLines: maxLine ?? 1,
    );
  }
}
