import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/widgets/account_before_auth.dart';
import 'package:icare/features/account/presentation/widgets/notifications_widgets/notifications_list.dart';
import 'package:icare/features/home/presentation/widgets/background_with_raduis_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !Util.checkUser()
            ? const AccountNotAuth()
            : RefreshIndicator(
                onRefresh: () => _buildRefresh(context),
                color: DMUtil.getPC(),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        HomeBackGroundWithRadius(
                          title: translate("profile.notification"),
                          enableBackIcon: true,
                        ),
                        const NotificationsList(),
                      ],
                    ),
                  ),
                )));
  }

  Future<void> _buildRefresh(BuildContext context) async {
    AccountBloc.get(context).add(const FetchAllNotificationsEvent());
  }
}
