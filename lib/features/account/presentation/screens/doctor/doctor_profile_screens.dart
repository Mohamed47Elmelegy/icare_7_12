import 'package:flutter/material.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/account/presentation/screens/doctor/doctor_profile_personal_tap_screen.dart';
import 'package:icare/features/account/presentation/screens/nurse/nurse_profile_prices_tap_screen.dart'; // Reusing modified version
import 'package:icare/features/doctor/presentation/screens/doctor_details_feedbacks_tap_screen.dart';

class DoctorProfileScreens extends StatelessWidget {
  const DoctorProfileScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, state) {
        var bloc = AccountBloc.get(ctx);
        int currentTap = bloc.currentProfileTapsIndex;
        if (currentTap == 0) {
          return const DoctorProfilePersonalTapScreen();
        } else if (currentTap == 1) {
          // Reusing NurseProfilePricesTapScreen which we modified to handle Doctors (hiding prices)
          // Ideally we would rename it or wrap it, but reusing is fine as verified.
          return const NurseProfilePricesTapScreen();
        } else {
          return const DoctorDetailsFeedBacksTapScreen();
        }
      },
    );
  }
}
