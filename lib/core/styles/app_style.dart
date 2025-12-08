import 'dart:io';

import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyle {
  //Font Text Style

  static const double verySmall = 13;
  static const double small = 14;
  static const double average = 15.6;
  static const double large = 18.2;
  static const double veryLarge = 22;

  static double appBarHeight = Platform.isIOS?60:53;

  static double paddingFromTop = Platform.isIOS?47:41;
  static const double paddingFromH = 15;
  static double paddingFromV = Platform.isIOS?42:24;


  static double iconsSize = 10.h + 10.w;

  static AppBar globalAppBar = AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: BackArrowButton(color: DMUtil.getWC(),),
  );

  static EdgeInsets globalPadding = EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w,vertical: AppStyle.paddingFromV.h);
  static Decoration globalDecoration = BoxDecoration(
      color: DMUtil.getBackGround(),
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
  );

}
