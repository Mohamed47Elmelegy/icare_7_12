import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_event.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/root_app/screens/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/root_app/bloc/root_event.dart';
import 'package:icare/features/root_app/bloc/root_state.dart';
import 'package:icare/features/shared_widgets/svg_asset_icon.dart';

class BottomNavBar extends StatelessWidget {
  final bool isRoot;
  const BottomNavBar({super.key, this.isRoot = true});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootBloc, RootState>(
      builder: (ctx, state) {
        var bloc = RootBloc.get(ctx);
        int currentIndex = bloc.currentScreenIndex;
        return BottomNavigationBar(
          onTap: (index) {
            if (isRoot == false) {
              Util.pushPageAndRemoveRoutes(const RootScreen(), context);
            }
            if (index == 0) {
              bloc.add(const ShowDrawerMenuEvent());
            } else {
              bloc.add(ChangeIndex(index: index, title: ""));
            }

            /// check if not get all nurses fetch it
            NurseBloc.get(context).add(const FetchAllNurseEvent(page: 2));
          },
          currentIndex: currentIndex,
          backgroundColor: DMUtil.getWC(),
          selectedItemColor: DMUtil.getPC(),
          unselectedItemColor: DMUtil.getD2C(),
          selectedLabelStyle: TextStyle(
              fontFamily: primaryFontReg,
              height: 1.5,
              fontSize: AppStyle.small.sp - 1),
          unselectedLabelStyle: TextStyle(
              fontFamily: primaryFontReg,
              height: 1.4,
              fontSize: AppStyle.small.sp - 1),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            if (Util.isAssistant() == true || Util.isNurse() == true) ...[
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                    size: 24.w,
                    color: currentIndex == 0
                        ? DMUtil.getSelectedIcon()
                        : DMUtil.getUnSelectedIcon(),
                  ),
                  label: "",
                  backgroundColor: DMUtil.getWC()),
              BottomNavigationBarItem(
                  icon: SvgAssetIconWidget(
                    iconPath: AppImages.homeSelected,
                    color: currentIndex == 1
                        ? DMUtil.getSelectedIcon()
                        : DMUtil.getUnSelectedIcon(),
                  ),
                  label: "",
                  backgroundColor: DMUtil.getWC()),
              BottomNavigationBarItem(
                  icon: SvgAssetIconWidget(
                    iconPath: AppImages.profile,
                    color: currentIndex == 2
                        ? DMUtil.getSelectedIcon()
                        : DMUtil.getUnSelectedIcon(),
                  ),
                  label: "",
                  backgroundColor: DMUtil.getWC()),
              BottomNavigationBarItem(
                  icon: SvgAssetIconWidget(
                    iconPath: AppImages.appointments,
                    color: currentIndex == 3
                        ? DMUtil.getSelectedIcon()
                        : DMUtil.getUnSelectedIcon(),
                  ),
                  label: "",
                  backgroundColor: DMUtil.getWC()),
            ] else ...[
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                    size: 24.w,
                    color: currentIndex == 0
                        ? DMUtil.getSelectedIcon()
                        : DMUtil.getUnSelectedIcon(),
                  ),
                  label: "",
                  backgroundColor: DMUtil.getWC()),
              BottomNavigationBarItem(
                  icon: SvgAssetIconWidget(
                    iconPath: AppImages.search,
                    color: currentIndex == 1
                        ? DMUtil.getSelectedIcon()
                        : DMUtil.getUnSelectedIcon(),
                  ),
                  label: "",
                  backgroundColor: DMUtil.getWC()),
              BottomNavigationBarItem(
                  icon: SvgAssetIconWidget(
                    iconPath: AppImages.homeSelected,
                    color: currentIndex == 2
                        ? DMUtil.getSelectedIcon()
                        : DMUtil.getUnSelectedIcon(),
                  ),
                  label: "",
                  backgroundColor: DMUtil.getWC()),
              BottomNavigationBarItem(
                  icon: SvgAssetIconWidget(
                    iconPath: AppImages.profile,
                    color: currentIndex == 3
                        ? DMUtil.getSelectedIcon()
                        : DMUtil.getUnSelectedIcon(),
                  ),
                  label: "",
                  backgroundColor: DMUtil.getWC()),
              BottomNavigationBarItem(
                  icon: SvgAssetIconWidget(
                    iconPath: AppImages.appointments,
                    color: currentIndex == 4
                        ? DMUtil.getSelectedIcon()
                        : DMUtil.getUnSelectedIcon(),
                  ),
                  label: "",
                  backgroundColor: DMUtil.getWC()),
            ],
          ],
        );
      },
    );
  }
}
