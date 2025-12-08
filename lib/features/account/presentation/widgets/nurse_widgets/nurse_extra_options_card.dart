import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/nurse/presentation/widgets/small_card_nurse_details.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/switch_profile_status.dart';

class ExtraOptionsNurseCardProfile extends StatelessWidget {
  const ExtraOptionsNurseCardProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc,AccountState>(
      builder: (ctx,state){
        var bloc = AccountBloc.get(ctx);
        var currentNurse = bloc.currentUser;
        if(currentNurse==null)return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SwitchProfileStatus(),
                CustomButton(
                  height: 25.w, 
                  width: 94.w, 
                  widget: CustomText(
                    text: translate("profile.emerg"),
                    fontWeight: FontWeight.w600,
                    fontSize: AppStyle.small.sp-1.2,
                    color: DMUtil.getWC(),
                  ),        
                  color: DMUtil.getRED(),
                  onPressed: ()async{
                    if(bloc.emergencyContactsList!=null && bloc.emergencyContactsList!.isNotEmpty){
                      for(var i in bloc.emergencyContactsList!){
                        await Util.sendSms(i);
                      }
                    }
                  },
                ),
              ],
            ),
            // CustomText(
            //   text: currentNurse.viewTypeText(),
            //   fontSize: AppStyle.small.sp,
            //   color: DMUtil.getD2C(),
            // ),
            // SizedBox(
            //   width: 200.w,
            //   child: CustomText(
            //     text: currentNurse.address ?? "",
            //     fontSize: AppStyle.small.sp,
            //     color: DMUtil.getD2C(),
            //     alignCenter: false,
            //     isEllipsis: true,
            //     maxLine: 1,
            //   ),
            // ),

            const SizedBox(height: 10,),

            const Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SmallProfileCards(title: "10K", subTitle: "patients",),
                SizedBox(width: 5,),
                SmallProfileCards(title: "5 years", subTitle: "experience",),
                SizedBox(width: 5,),
                SmallProfileCards(title: "5.0", subTitle: "Avg Rating",),
              ],
            ),
          ],
        );
      },
    );
  }
}




