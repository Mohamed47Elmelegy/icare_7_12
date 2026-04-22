import 'package:icare/core/constants/constant.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class DMUtil {
  static bool currentThemeIsDark() {
    return SharedPref()
            .getPreferenceString(Constants.userTheme)
            .toString()
            .trim() ==
        "dark";
  }

  /// get primary color
  static Color getPC() {
    return kPrimary;
  }

  static Color getPcSc() {
    return kFifthPrimary;
  }

  static Color getPC2() {
    return kSecondPrimary;
  }

  static Color getPC3() {
    return currentThemeIsDark() ? kThirdPrimary : kThirdPrimary;
  }

  static Color getPC4() {
    return currentThemeIsDark() ? kFourthPrimary : kFourthPrimary;
  }

  static Color getText() {
    return kText2;
  }

  static Color getText2() {
    return kText3;
  }

  /// get background color
  static Color getBC() {
    return currentThemeIsDark() ? kDark : kWhite;
  }

  /// get background color
  static Color getWC() {
    return currentThemeIsDark() ? kDark : kWhite;
  }

  static Color getWCCat() {
    return currentThemeIsDark() ? kRed : kWhite;
  }

  static Color getSelectedIcon() {
    return currentThemeIsDark() ? kWhite : kSelectedIcon;
  }

  static Color getUnSelectedIcon() {
    return currentThemeIsDark() ? kWhite : kUnSelectedIcon;
  }

  /// get background color
  static Color getRED() {
    return kRed;
  }

  static Color getGreen() {
    return currentThemeIsDark() ? kBackGreenColor : kBackGreenColor;
  }

  static Color getGreen2() {
    return currentThemeIsDark() ? kGreenColor : kGreenColor;
  }

  static Color getREdOPACITY() {
    return kRed.withValues(alpha: 0.4);
  }

  /// get categories background color
  static Color getBCC() {
    return kBackGround;
  }

  static Color getBCD() {
    return currentThemeIsDark() ? kRed : kBackGround;
  }

  static Color getBCIcon() {
    return currentThemeIsDark() ? kWhite : kRed;
  }

  /// get Dark Color
  static Color getDC() {
    return currentThemeIsDark() ? kWhite : kBlack;
  }

  /// get Dark Color
  static Color getD2C() {
    return currentThemeIsDark() ? kBackGround : kBlack2;
  }

  static Color getDLight() {
    return currentThemeIsDark() ? kWhite : kDark;
  }

  static Color getOpacity() {
    return currentThemeIsDark() ? kWhite : kBackGround2;
  }

  static Color getBackGround() {
    return currentThemeIsDark() ? kDark : kBackGroundN;
  }

  static Color getReviewColor() {
    return currentThemeIsDark() ? kDark : const Color(0xffF8A200);
  }

  static Color getButtonOrangeColor() {
    return currentThemeIsDark() ? kOrangeButton : kOrangeButton;
  }

  static Color getBookButtonColor() {
    return currentThemeIsDark() ? kBookButtonColor : kBookButtonColor;
  }

  static Color getBackGroundTaps() {
    return currentThemeIsDark() ? kBackGroundTaps : kBackGroundTaps;
  }

  static Color getBackGroundDrawer() {
    return currentThemeIsDark() ? kBackGroundDrawer : kBackGroundDrawer;
  }
}
