import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class SwitchProfileStatus extends StatelessWidget {
  const SwitchProfileStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomText(
          text: translate("profile.offline"),
          fontWeight: FontWeight.w600,
          fontSize: AppStyle.verySmall.sp,
        ),
        BlocBuilder<AccountBloc,AccountState>(
          builder: (ctx,state){
            var bloc = AccountBloc.get(ctx);
            return Switch(
              value: bloc.isOnline,
              activeColor: DMUtil.getPC(),
              onChanged: (val)=> bloc.add(const SwitchProfileStatusEvent()),
            );
          },
        ),
        CustomText(
          text: translate("profile.online"),
          fontWeight: FontWeight.w600,
          fontSize: AppStyle.verySmall.sp,
        ),

      ],
    );
  }
}
