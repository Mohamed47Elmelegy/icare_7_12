// ignore_for_file: must_be_immutable

import 'package:icare/core/styles/my_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';

class CustomTextFromFieldAuth extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final Function validator;
  final bool obscureText;
  Widget? prefixIcon;
  Widget? suffixIcon;
  final bool isLabelError;
  final double radius;
  bool? smallPadding;
  Color? cursorColor;
  int? maxLines;
  bool? smallHintText;
  Function? onChanged;
  Function? onFieldSubmitted;
  Color? hintColor;
  bool? filled;
  bool? enabled;
  TextInputType? textInputType;

  CustomTextFromFieldAuth({
    required this.hintText,
    required this.textEditingController,
    required this.validator,
    required this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    required this.isLabelError,
    required this.radius,
    this.smallPadding,
    this.cursorColor,
    this.maxLines,
    this.smallHintText = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.hintColor,
    this.textInputType,
    this.filled = false,
    this.enabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: TextFormField(
        autofocus: false,
        controller: textEditingController,
        maxLines: maxLines ?? 1,
        validator: (value) => validator(value),
        obscureText: obscureText,
        enabled: enabled ?? true,
        cursorColor: cursorColor ?? Colors.white,
        keyboardType: textInputType ?? TextInputType.text,
        onChanged: (val) =>
            onChanged == null ? debugPrint("") : onChanged!(val),
        onFieldSubmitted: (val) =>
            onFieldSubmitted == null ? debugPrint("") : onFieldSubmitted!(val),
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          filled: filled,
          contentPadding: smallPadding == true
              ? const EdgeInsets.symmetric(vertical: 1, horizontal: 2)
              : null,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: AppStyle.small.sp,
              color: Colors.black,
              fontFamily: primaryFontReg),
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
