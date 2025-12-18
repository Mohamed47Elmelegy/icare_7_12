import 'package:flutter/material.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final double width;
  final Widget widget;
  final Color color;
  final Function()? onPressed;
  final Color? sideColor;
  final double? sideWidth;
  final double circular;
  final bool? withShadow;

  const CustomButton({
    super.key,
    required this.height,
    required this.width,
    required this.widget,
    required this.color,
    required this.onPressed,
    this.withShadow,
    this.sideColor,
    this.sideWidth,
    this.circular = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: withShadow != null && withShadow == true
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(circular),
              boxShadow: [
                  BoxShadow(
                      color: DMUtil.getPC2().withOpacity(0.3), blurRadius: 10),
                  BoxShadow(
                      color: DMUtil.getPC2().withOpacity(0.3), blurRadius: 10),
                  BoxShadow(
                      color: DMUtil.getPC2().withOpacity(0.3), blurRadius: 10),
                ])
          : const BoxDecoration(),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(circular),
            side: BorderSide(
              color: sideColor ?? color,
              width: sideWidth ?? 0.0,
            ),
          ),
        ),
        child: widget,
      ),
    );
  }
}
