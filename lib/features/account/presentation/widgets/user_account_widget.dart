
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/screens/edit_profile_screen.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class UserAccountWidget extends StatelessWidget {
  const UserAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DMUtil.getWC(),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w - 4,),
      child: BlocBuilder<AccountBloc,AccountState>(
        builder: (ctx,state){
          var bloc = AccountBloc.get(ctx);
          var user = bloc.currentUser;
          if(user==null)return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w - 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: user.userName.toString(),
                      color: DMUtil.getD2C(),
                      fontWeight: FontWeight.w600,
                      fontSize: AppStyle.average.sp + 2,
                    ),
                    const SizedBox(height: 5,),
                    CustomText(
                      text: user.email.toString(),
                      color: DMUtil.getD2C(),
                      fontSize: AppStyle.average.sp,
                    ),
                  ],
                )
              ),
              const SizedBox(height: 2,),

             TextButton(
                 onPressed: ()=> Util.pushPage(const EditProfilePage(), context),
                 child: CustomText(
                   text: translate("profile.edit_info"),
                   fontSize: AppStyle.small.sp-1,
                   color: DMUtil.getD2C(),
                   fontWeight: FontWeight.w600,
                 ),
             ),
            ],
          );
        },
      )
    );
  }
}
