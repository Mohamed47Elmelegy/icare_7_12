import 'package:icare/core/constants/constant.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/root_app/bloc/root_event.dart';
import 'package:icare/features/root_app/screens/root_screen.dart';
import 'package:icare/features/setting/presentation/screens/help_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/setting/presentation/widgets/small_widgets.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class SettingSectionWidget extends StatelessWidget {
  const SettingSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8.w,
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w - 4),
          child: CustomText(
            text: translate("activity_setting.app_bar"),
            color: DMUtil.getD2C().withValues(alpha: 0.6),
            fontWeight: FontWeight.w600,
            fontSize: AppStyle.average.sp,
          ),
        ),
        Container(
          color: DMUtil.getWC(),
          margin: EdgeInsets.symmetric(vertical: 8.w),
          padding:
              EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w - 4),
          child: Column(
            children: [
              SettingLineOption(
                title: translate("button.change_language"),
                widget: SizedBox(
                  height: 30.h,
                  width: 90.w,
                  child: DropdownButton(
                    isExpanded: true,
                    dropdownColor: DMUtil.getWC(),
                    alignment: Alignment.center,
                    underline: const SizedBox.shrink(),
                    style: TextStyle(
                      color: DMUtil.getDC(),
                      fontSize: 12.sp,
                    ),
                    hint: CustomText(
                      text: Util.getLang() == "ar" ? "عربي" : "English",
                      color: DMUtil.getDC(),
                      fontSize: AppStyle.average.sp,
                    ),
                    onChanged: (val) {
                      // if(val=="English"){
                      //   Util.changeLang(ctx: context,lang: "en_US");
                      // }else{
                      //   Util.changeLang(ctx: context,lang: "ar");
                      // }
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: DMUtil.getDC(),
                      size: 23.w,
                    ),
                    items: items
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: CustomText(
                                text: e.toString(),
                                color: DMUtil.getDC(),
                                fontSize: AppStyle.average.sp - 2.w,
                              ),
                            ))
                        .toList(),
                    value: Util.getLang() == "ar" ? "عربي" : "English",
                  ),
                ),
              ),
              SettingLineOption(
                title: translate("profile.notification"),
                widget: BlocBuilder<AccountBloc, AccountState>(
                  builder: (ctx, state) {
                    var bloc = AccountBloc.get(ctx);
                    var isEnabled = bloc.isEnabledNotification;
                    return SizedBox(
                      height: 25.h,
                      child: Switch(
                        value: isEnabled,
                        activeThumbColor: DMUtil.getRED(),
                        onChanged: (val) =>
                            bloc.add(const ChangeNotificationModeEvent()),
                      ),
                    );
                  },
                ),
              ),
              SettingLineOption(
                title: translate("activity_setting.dark_mode"),
                widget: SizedBox(
                  height: 25.h,
                  child: Switch(
                      value: DMUtil.currentThemeIsDark(),
                      activeThumbColor: DMUtil.getRED(),
                      onChanged: (val) {
                        SharedPref().setPreferencesString(Constants.userTheme,
                            DMUtil.currentThemeIsDark() ? "light" : "dark");
                        RootBloc.get(context)
                            .add(const ChangeIndex(index: 4, title: ""));
                        Util.pushPageAndRemoveRoutes(
                            const RootScreen(), context);
                      }),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.w,
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w - 4),
          child: CustomText(
            text: translate("drawer.help_center"),
            color: DMUtil.getD2C().withValues(alpha: 0.6),
            fontWeight: FontWeight.w600,
            fontSize: AppStyle.average.sp,
          ),
        ),
        Container(
          color: DMUtil.getWC(),
          margin: EdgeInsets.symmetric(vertical: 8.w),
          padding:
              EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w - 4),
          child: SettingLineOption(
              title: translate("drawer.help_center"),
              onTap: () => Util.pushPage(const HelpCenterScreen(), context)),
        )
      ],
    );
  }

  static var items = ['عربي', 'English'];
}
