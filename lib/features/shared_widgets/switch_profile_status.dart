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
          color: DMUtil.getWC(),
        ),
        BlocBuilder<AccountBloc, AccountState>(
          builder: (ctx, state) {
            var bloc = AccountBloc.get(ctx);
            return Transform.scale(
              scale: 0.8, // Adjust size if needed
              child: Switch(
                value: bloc.isOnline,
                activeThumbColor: Colors.white,
                activeTrackColor: DMUtil.getPcSc(),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (val) => bloc.add(const SwitchProfileStatusEvent()),
              ),
            );
          },
        ),
        CustomText(
          text: translate("profile.online"),
          fontWeight: FontWeight.w600,
          fontSize: AppStyle.verySmall.sp,
          color: DMUtil.getWC(),
        ),
      ],
    );
  }
}
