import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/screens/notifications/notifications_screen.dart';
import 'package:icare/features/account/presentation/widgets/account_after_auth.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/root_app/bloc/root_event.dart';
import 'package:icare/features/root_app/widgets/drawer_item_line.dart';
import 'package:icare/features/shared_widgets/custom_dialogs.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class MainDrawerSection extends StatelessWidget {
  final BuildContext ctx;
  const MainDrawerSection({super.key, required this.ctx});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AccountAuthCard(
          darkText: true,
          isDrawer: true,
        ),
        SizedBox(
          height: 10.w,
        ),
        ItemLineDrawer(
          title: translate("icare.my_appointments"),
          icon: Icon(Icons.date_range, size: 20.w, color: DMUtil.getPC2()),
          fn: () {
            Scaffold.of(ctx).closeDrawer();
            RootBloc.get(context).add(const ChangeIndex(index: 0, title: ""));
          },
        ),
        ItemLineDrawer(
          title: translate("icare.new_appointment"),
          icon: Icon(Icons.add_circle_outline,
              size: 20.w, color: DMUtil.getPC2()),
          fn: () {
            Scaffold.of(ctx).closeDrawer();
            RootBloc.get(context).add(const ChangeIndex(index: 0, title: ""));
          },
        ),
        ItemLineDrawer(
          title: translate("icare.medical_records"),
          icon: Icon(Icons.file_copy_outlined,
              size: 20.w, color: DMUtil.getPC2()),
          fn: () {
            Scaffold.of(ctx).closeDrawer();
            RootBloc.get(context).add(const ChangeIndex(index: 0, title: ""));
          },
        ),
        ItemLineDrawer(
          title: translate("icare.notification"),
          icon: NotificationIcon(
            color: DMUtil.getPC2(),
          ),
          fn: () {
            Scaffold.of(ctx).closeDrawer();
            RootBloc.get(context).add(const ChangeIndex(index: 0, title: ""));
            Util.pushPage(const NotificationsScreen(), context);
          },
        ),
        ItemLineDrawer(
          title: translate("icare.payment_methods"),
          icon: Icon(
            Icons.payment,
            color: DMUtil.getPC2(),
          ),
          fn: () {
            Scaffold.of(ctx).closeDrawer();
            RootBloc.get(context).add(const ChangeIndex(index: 0, title: ""));
          },
        ),
        ItemLineDrawer(
          title: translate("profile.my_account"),
          icon: Icon(
            Icons.account_box_outlined,
            color: DMUtil.getPC2(),
          ),
          fn: () {
            Scaffold.of(ctx).closeDrawer();
            RootBloc.get(context).add(const ChangeIndex(index: 2, title: ""));
          },
        ),
        if (Util.checkUser()) ...[
          ItemLineDrawer(
            title: translate("activity_setting.sign_out"),
            icon: Icon(
              Icons.logout,
              size: 20.w,
              color: DMUtil.getPC2().withOpacity(0.7),
            ),
            fn: () {
              Scaffold.of(ctx).closeDrawer();
              CustomDialogs.signOut(context);
            },
          ),
        ],
      ],
    );
  }
}
