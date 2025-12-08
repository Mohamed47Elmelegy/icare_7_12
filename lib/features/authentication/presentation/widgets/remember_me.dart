import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_event.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class RememberMeWidget extends StatelessWidget {
  const RememberMeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc,AuthState>(
      builder: (ctx,state){
        var bloc = AuthBloc.get(ctx);
        return InkWell(
          onTap: () => bloc.add(const RememberMeEvent()),
          child: Row(
            children: [
              Checkbox(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))
                ),
                value: bloc.rememberMe,
                checkColor: DMUtil.getWC(),
                activeColor: kPrimary,
                side: BorderSide(color: DMUtil.getDC(),),
                onChanged: (val)=> bloc.add(const RememberMeEvent()),
              ),
              CustomText(
                  text: translate("login.remember_me"),
                  color: DMUtil.getDC(),
                  fontFamily: primaryFontSemiBold,
                  fontSize: AppStyle.small.sp),
            ],
          ),
        );
      },
    );
  }
}
