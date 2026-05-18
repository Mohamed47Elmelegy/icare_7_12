// ignore_for_file: must_be_immutable

import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';

class CustomTextFromField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController textEditingController;
  final Function validator;
  final bool obscureText;
  Widget? prefixIcon;
  Widget? suffixIcon;
  final bool isLabelError;
  final double radius;
  bool? smallPadding;
  bool? hasBorder;
  bool? strokeBorder;
  Color? cursorColor;
  int? maxLines;
  Function? onChanged;
  Function? onFieldSubmitted;
  Color? hintColor;
  bool? filled;
  bool? enabled;
  TextInputType? textInputType;
  Color? borderColor;
  double? borderWidth;
  double? height;

  CustomTextFromField({
    required this.hintText,
    required this.labelText,
    required this.textEditingController,
    required this.validator,
    required this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    required this.isLabelError,
    required this.radius,
    this.smallPadding,
    this.hasBorder,
    this.strokeBorder,
    this.cursorColor,
    this.maxLines,
    this.onChanged,
    this.onFieldSubmitted,
    this.hintColor,
    this.textInputType,
    this.filled = false,
    this.enabled,
    this.borderWidth,
    this.borderColor,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height?.w ?? 41.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        color: DMUtil.getWC(),
      ),
      child: TextFormField(
        autofocus: false,
        controller: textEditingController,
        maxLines: maxLines ?? 1,
        validator: (value) => validator(value),
        obscureText: obscureText,
        enabled: enabled ?? true,
        cursorColor: cursorColor ?? DMUtil.getD2C(),
        keyboardType: textInputType ?? TextInputType.text,
        onChanged: (val) => onChanged?.call(val),
        onFieldSubmitted: (val) => onFieldSubmitted?.call(val),
        style: TextStyle(
          color: DMUtil.getD2C(),
          fontSize: AppStyle.small.sp,
        ),
        decoration: InputDecoration(
          filled: filled,
          contentPadding: smallPadding == true
              ? EdgeInsets.symmetric(vertical: 7.w, horizontal: 6.w)
              : null,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: OutlineInputBorder(
            borderSide: hasBorder == true
                ? BorderSide(
                    color: borderColor ?? DMUtil.getD2C(),
                    width: borderWidth ?? 1.0)
                : const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: hasBorder == true
                ? strokeBorder == true
                    ? BorderSide(
                        color: DMUtil.getD2C(), width: borderWidth ?? 1.0)
                    : BorderSide(
                        color: DMUtil.getOpacity(), width: borderWidth ?? 1.0)
                : const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: hasBorder == true
                ? strokeBorder == true
                    ? BorderSide(
                        color: DMUtil.getD2C(), width: borderWidth ?? 1.0)
                    : BorderSide(
                        color: DMUtil.getOpacity(), width: borderWidth ?? 1.0)
                : const BorderSide(color: Colors.white),
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
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: AppStyle.small.sp,
            color: hintColor ?? Colors.grey,
          ),
          label: Text(
            labelText,
            style: TextStyle(
              color: isLabelError ? Colors.red : DMUtil.getD2C(),
              fontSize: AppStyle.small.sp,
            ),
          ),
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
