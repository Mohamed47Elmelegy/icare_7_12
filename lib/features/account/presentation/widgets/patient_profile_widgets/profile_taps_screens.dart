
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/personal_tap_screen.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/profile_medications_tap_screen.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/report_tap_screen.dart';
import 'package:flutter/material.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class ProfileTapsScreens extends StatelessWidget {
  final bool? isNurseEditMode;
  const ProfileTapsScreens({super.key,this.isNurseEditMode=false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc,AccountState>(
      builder: (ctx,state){
        var bloc = AccountBloc.get(ctx);
        int currentTap = bloc.currentProfileTapsIndex;
        if(state is FetchProfileDataState && state.response.isLoad==true)return Padding(padding: const EdgeInsets.all(20),child: CircularProgressIndicator(color: DMUtil.getPC(),),);
        if(currentTap==0) {
          return PersonalTapScreen(isNurseEditMode: isNurseEditMode,);
        }else if(currentTap==1){
         return const ProfileMedicationsTapScreen();
        }else{
         return const ReportTapScreen();
        }
      },
    );
  }
}




