import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/screens/notifications/notifications_screen.dart';
import 'package:icare/features/booking/presentation/screens/order_screen.dart';
import 'package:icare/features/home/presentation/screens/home.dart';
import 'package:icare/features/root_app/bloc/root_event.dart';
import 'package:icare/features/root_app/widgets/customized_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/account/presentation/screens/profile_screen.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/root_app/bloc/root_state.dart';
import 'package:icare/features/root_app/widgets/bottom_nav_bar.dart';
import 'package:icare/features/search/presentation/screens/search_screen.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootBloc, RootState>(
      builder: (ctx, state) {
        var bloc = RootBloc.get(ctx);
        int index = bloc.currentScreenIndex;
        return Scaffold(
          bottomNavigationBar: const BottomNavBar(),
          backgroundColor: DMUtil.getWC(),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GestureDetector(
                onTap: () => bloc.drawerMenuEnabled == true
                    ? bloc.add(const ShowDrawerMenuEvent())
                    : null,
                child: Container(
                    height: double.infinity,
                    color: bloc.drawerMenuEnabled
                        ? Colors.black45
                        : Colors.transparent,
                    child: Opacity(
                      opacity: bloc.drawerMenuEnabled ? 0.2 : 1,
                      child: Stack(
                        children: [
                          if (Util.isAssistant() == true ||
                              Util.isNurse() == true) ...[
                            if (index == 1) ...[
                              const HomeScreen()
                            ] else if (index == 2) ...[
                              const ProfileScreen()
                            ] else if (index == 3) ...[
                              const OrderScreen(),
                            ],
                          ] else ...[
                            if (index == 1) ...[
                              const SearchScreen()
                            ] else if (index == 2) ...[
                              const HomeScreen()
                            ] else if (index == 3) ...[
                              const ProfileScreen()
                            ] else if (index == 4) ...[
                              const OrderScreen(),
                            ],
                          ],
                        ],
                      ),
                    )),
              ),
              if (bloc.drawerMenuEnabled) ...[
                Positioned(
                  bottom: 1.w,
                  left: Util.getLang() == "ar" ? null : 1.w,
                  right: Util.getLang() != "ar" ? null : 1.w,
                  child: const CustomizedMenuWidget(),
                )
              ],
            ],
          ),
        );
      },
    );
  }
}
