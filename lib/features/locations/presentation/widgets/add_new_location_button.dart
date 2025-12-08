// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/locations/presentation/screens/add_location.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class AddNewLocationButton extends StatelessWidget {
  const AddNewLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Platform.isIOS?25:10),
      child: CustomButton(
        height: 40.h,
        width: double.infinity,
        circular: 0,
        widget: CustomText(
          color: Colors.white,
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          text: translate("map.add_location"),
        ),
        color: DMUtil.getRED(),
        onPressed: ()=> Util.pushPage(const AddNewLocationScreen(type: "local",), context),
      ),
    );
  }
}
