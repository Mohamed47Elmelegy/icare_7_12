import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/screens/notifications/notifications_screen.dart';
import 'package:icare/features/account/presentation/widgets/profile_image_with_action.dart';
import 'package:icare/features/nurse/presentation/screens/vertical_specialists_list.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/root_app/bloc/root_event.dart';
import 'package:icare/features/root_app/screens/welcome_screens/new_experience_screen.dart';
import 'package:icare/features/root_app/widgets/drawer_item_line.dart';
import 'package:icare/features/shared_widgets/custom_dialogs.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/svg_asset_icon.dart';

class CustomizedMenuWidget extends StatelessWidget {
  const CustomizedMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220.w,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: DMUtil.getWC()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          if (!Util.checkUser())
            ItemLineDrawer(
              title: translate("login.app_bar"),
              icon: Icon(
                Icons.people,
                color: DMUtil.getUnSelectedIcon(),
              ),
              fn: () => Util.pushPage(const NewExperienceScreen(), context),
            ),
          if (Util.isCustomer())
            ItemLineDrawer(
              title: translate("nurse.all_nurses"),
              icon: Icon(
                Icons.people,
                color: DMUtil.getUnSelectedIcon(),
              ),
              fn: () => Util.pushPage(const AllSpecialistsScreen(), context),
            ),
          if (Util.checkUser()) ...[
            ItemLineDrawer(
              title: translate("profile.profile"),
              icon: SvgAssetIconWidget(
                iconPath: AppImages.profile,
                color: DMUtil.getUnSelectedIcon(),
              ),
              fn: () {
                int index = Util.isCustomer() ? 3 : 2;
                RootBloc.get(context).add(ChangeIndex(index: index, title: ""));
                RootBloc.get(context).add(const ShowDrawerMenuEvent());
              },
            ),
            ItemLineDrawer(
              title: translate("profile.notification"),
              icon: SvgAssetIconWidget(
                iconPath: AppImages.notification,
                color: DMUtil.getUnSelectedIcon(),
              ),
              fn: () {
                RootBloc.get(context).add(const ShowDrawerMenuEvent());
                Util.pushPage(const NotificationsScreen(), context);
              },
            ),
            if (Util.isCustomer())
              ItemLineDrawer(
                title: translate("icare.new_appointment"),
                icon: Icon(
                  Icons.add_circle_outline,
                  color: DMUtil.getUnSelectedIcon(),
                ),
                fn: () {
                  RootBloc.get(context).add(const ShowDrawerMenuEvent());
                  Util.pushPage(const AllSpecialistsScreen(), context);
                },
              ),
            ItemLineDrawer(
              title: translate("icare.my_appointments"),
              icon: Icon(
                Icons.date_range_sharp,
                color: DMUtil.getUnSelectedIcon(),
              ),
              fn: () {
                int index = Util.isCustomer() ? 4 : 3;
                RootBloc.get(context).add(ChangeIndex(index: index, title: ""));
                RootBloc.get(context).add(const ShowDrawerMenuEvent());
              },
            ),
          ],
          ItemLineDrawer(
            title: translate("button.change_language"),
            icon: Icon(
              Icons.language,
              color: DMUtil.getUnSelectedIcon(),
            ),
            fn: () => Util.changeLang(ctx: context),
          ),
          if (Util.checkUser()) ...[
            ItemLineDrawer(
              title: translate("activity_setting.sign_out"),
              icon: Icon(
                Icons.logout,
                size: 20.w,
                color: DMUtil.getUnSelectedIcon(),
              ),
              fn: () {
                RootBloc.get(context).add(const ShowDrawerMenuEvent());
                CustomDialogs.signOut(context);
              },
            ),
            Container(
              color: DMUtil.getBackGroundDrawer(),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ProfileImageEdit(
                        enableEditIcon: false,
                        img: Util.isCustomer()
                            ? AppImages.avatar
                            : AppImages.nurseImg,
                        enablePadding: false,
                        iconSize: 28,
                      ),
                      // const CircleProfileImage(),
                      const SizedBox(
                        width: 10,
                      ),
                      BlocBuilder<AccountBloc, AccountState>(
                        builder: (ctx, state) {
                          var bloc = AccountBloc.get(ctx);
                          if (bloc.currentUser == null)
                            return SizedBox.shrink();
                          return SizedBox(
                            width: 100.w,
                            child: CustomText(
                              text: bloc.currentUser!.userName.toString(),
                              fontSize: AppStyle.small.sp,
                              fontWeight: FontWeight.w600,
                              isEllipsis: true,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () =>
                        RootBloc.get(context).add(const ShowDrawerMenuEvent()),
                    child: Icon(
                      Icons.close,
                      size: 22.w,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
