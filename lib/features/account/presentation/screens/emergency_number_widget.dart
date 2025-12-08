// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/widgets/nurse_widgets/edit_info_list.dart';
import 'package:icare/features/authentication/presentation/widgets/nurse/add_btn_row.dart';
import 'package:icare/features/shared_widgets/custom_dialogs.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';

class EmergencyNumberWidget extends StatelessWidget {
  const EmergencyNumberWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc,AccountState>(
      builder: (ctx,state){
        var bloc = AccountBloc.get(ctx);
        var currentUser = bloc.currentUser;
        if(currentUser==null)return const SizedBox.shrink();
        return Column(
          children: [
            AddRowWithTitle(
              onTap: ()async{
                var bloc = AccountBloc.get(context);
                var res = await CustomDialogs.addNewValue(context);
                if(res !=null && res != ""){
                  bloc.emergencyContactsList ??= [];
                  int index = bloc.emergencyContactsList!.indexWhere((element) => element == res);
                  if(index!=-1)return;
                  if(bloc.emergencyContactsList?.length==2){
                    return SnackBarBuilder.showFeedBackMessage(context, translate("nurse.you_can_add_just_two_numbers"), DMUtil.getRED());
                  }
                  bloc.emergencyContactsList!.add(res);
                  if(Util.isCustomer()){
                     bloc.add(UpdateProfileEvent(user: {
                      "emergency_contacts":bloc.emergencyContactsList.toString()
                    }));
                    return;
                  }

                  //if current user_type is nurse or assistant 
                  bloc.add(UpdateNurseDataEvent(emergencyContactsList: bloc.emergencyContactsList));
                }
              },
              title: translate("profile.emergency_contacts"),
            ),
            const SizedBox(height: 10,),
            const NurseOptionsValueRowAccount(listType: "emergency_contacts",),
          ],
        );
      },
    );
  }
}
