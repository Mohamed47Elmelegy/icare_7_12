import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/shared_widgets/simple_taps.dart';

class ProfileTaps extends StatelessWidget {
  const ProfileTaps({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, state) {
        var bloc = AccountBloc.get(ctx);
        return Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: DMUtil.getBackGroundTaps()),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TapWidget(
                  title: translate("profile.personal"),
                  index: 0,
                  width: 90,
                  selected: bloc.currentProfileTapsIndex == 0,
                  fn: () => bloc.add(const SwitchProfileTapsEvent(index: 0)),
                ),
                TapWidget(
                    title: translate("profile.medications"),
                    index: 1,
                    width: 90,
                    selected: bloc.currentProfileTapsIndex == 1,
                    fn: () => bloc.add(const SwitchProfileTapsEvent(index: 1))),
                TapWidget(
                    title: translate("profile.tracking_reports"),
                    index: 2,
                    width: 110,
                    selected: bloc.currentProfileTapsIndex == 2,
                    fn: () => bloc.add(const SwitchProfileTapsEvent(index: 2))),
                TapWidget(
                    title: translate("order.title"),
                    index: 3,
                    width: 90,
                    selected: bloc.currentProfileTapsIndex == 3,
                    fn: () => bloc.add(const SwitchProfileTapsEvent(index: 3))),
              ],
            ),
          ),
        );
      },
    );
  }
}
