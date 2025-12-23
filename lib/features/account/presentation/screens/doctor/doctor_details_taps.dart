import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/doctor/presentation/bloc/doctor_event.dart';
import 'package:icare/features/doctor/presentation/bloc/doctors_bloc.dart';
import 'package:icare/features/shared_widgets/simple_taps.dart';

class DoctorDetailsTaps extends StatelessWidget {
  const DoctorDetailsTaps({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, state) {
        var bloc = AccountBloc.get(ctx);
        return Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: DMUtil.getBackGroundTaps()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TapWidget(
                title: translate("profile.personal"),
                index: 0,
                selected: bloc.currentProfileTapsIndex == 0,
                fn: () => bloc.add(const SwitchProfileTapsEvent(index: 0)),
              ),
              TapWidget(
                title: translate("home.specialities"),
                index: 1,
                selected: bloc.currentProfileTapsIndex == 1,
                fn: () => bloc.add(const SwitchProfileTapsEvent(index: 1)),
              ),
              TapWidget(
                title: translate(
                    "nurse.feedbacks"), // Using nurse translation or generic if available
                index: 2,
                selected: bloc.currentProfileTapsIndex == 2,
                fn: () {
                  if (bloc.currentUser != null &&
                      bloc.currentUser!.doctor != null) {
                    DoctorBloc.get(context).add(UpdateCurrentDoctorEvent(
                        doctor: bloc.currentUser!.doctor!));
                  }
                  bloc.add(const SwitchProfileTapsEvent(index: 2));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
