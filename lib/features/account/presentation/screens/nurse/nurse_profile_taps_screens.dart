import 'package:flutter/material.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/account/presentation/screens/nurse/nurse_profile_personal_tap_screen.dart';
import 'package:icare/features/account/presentation/screens/nurse/nurse_profile_prices_tap_screen.dart';
import 'package:icare/features/nurse/presentation/screens/nurse_details_feedbacks_tap_screen.dart';

class NurseProfileScreens extends StatelessWidget {
  const NurseProfileScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, state) {
        var bloc = AccountBloc.get(ctx);
        int currentTap = bloc.currentProfileTapsIndex;
        if (currentTap == 0) {
          return const NurseProfilePersonalTapScreen();
        } else if (currentTap == 1) {
          return const NurseProfilePricesTapScreen();
        } else {
          return const NurseDetailsFeedBacksTapScreen();
        }
      },
    );
  }
}
