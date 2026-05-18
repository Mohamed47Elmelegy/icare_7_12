import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
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
import 'package:icare/core/di/injection_core.dart';
import 'package:icare/core/coordinator/feature_preload_manager.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({
    super.key,
  });

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() {
    super.initState();
    // No longer triggering preload in initState as it's handled by BlocListener
    // which reacts to the initial success state or navigation events.
  }

  void _triggerPreload() {
    if (!mounted) return;
    final bloc = RootBloc.get(context);
    final isProfessional =
        Util.isAssistant() || Util.isNurse() || Util.isDoctor();

    sl<FeaturePreloadManager>().preloadForIndex(
      bloc.currentScreenIndex,
      isProfessional,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RootBloc, RootState>(
      listener: (context, state) {
        if (state is RootSuccessState) {
          _triggerPreload();
        }
      },
      child: Scaffold(
        bottomNavigationBar: const BottomNavBar(),
        backgroundColor: DMUtil.getWC(),
        body: BlocSelector<RootBloc, RootState, (int, bool)>(
          selector: (state) {
            final bloc = RootBloc.get(context);
            return (bloc.currentScreenIndex, bloc.drawerMenuEnabled);
          },
          builder: (ctx, data) {
            final index = data.$1;
            final drawerEnabled = data.$2;
            final bloc = RootBloc.get(ctx);

            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GestureDetector(
                  onTap: () => drawerEnabled == true
                      ? bloc.add(const ShowDrawerMenuEvent())
                      : null,
                  child: Container(
                    height: double.infinity,
                    color: drawerEnabled ? Colors.black45 : Colors.transparent,
                    child: Opacity(
                      opacity: drawerEnabled ? 0.2 : 1,
                      child: _buildScreen(index),
                    ),
                  ),
                ),
                if (drawerEnabled) ...[
                  Positioned(
                    bottom: 1.w,
                    left: Util.getLang() == "ar" ? null : 1.w,
                    right: Util.getLang() != "ar" ? null : 1.w,
                    child: const CustomizedMenuWidget(),
                  )
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildScreen(int index) {
    final isProfessional =
        Util.isAssistant() || Util.isNurse() || Util.isDoctor();

    if (isProfessional) {
      if (index == 1) return const HomeScreen();
      if (index == 2) return const ProfileScreen();
      if (index == 3) return const OrderScreen();
    } else {
      if (index == 1) return const SearchScreen();
      if (index == 2) return const HomeScreen();
      if (index == 3) return const ProfileScreen();
      if (index == 4) return const OrderScreen();
    }
    return const SizedBox.shrink();
  }
}
