import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/allergies_section.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/dot_with_title.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/info_row.dart';
import 'package:flutter/material.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';


class PersonalTapScreen extends StatelessWidget {
  final bool? isNurseEditMode;
  const PersonalTapScreen({super.key,this.isNurseEditMode=false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc,AccountState>(
      builder: (ctx,state){
        var bloc = AccountBloc.get(ctx);
        var currentUser = bloc.currentUser;
        if(currentUser==null)return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(isNurseEditMode==false)...[
              Stack(
              alignment: Alignment.centerLeft,
                children: [
                  InfoRow(iconData: Icons.phone, value: currentUser.phoneNumber.toString()),
                  CustomButton(
                    height: 25.w, 
                    width: 85.w, 
                    widget: CustomText(
                      text: translate("profile.emergency"),
                      fontWeight: FontWeight.w600,
                      fontSize: AppStyle.small.sp-1.2,
                      color: DMUtil.getRED(),
                    ),        
                    color: DMUtil.getWC(),
                    sideWidth: 1,
                    sideColor: DMUtil.getRED(),
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
              InfoRow(iconData: Icons.email, value: currentUser.email.toString()),
              InfoRow(iconData: Icons.location_on_outlined, value: currentUser.address.toString()),

              const Divider(height: 30,),
            ],
            const AllergiesSection(),
            const Divider(height: 30,),
            CustomText(
              text: translate("profile.medical_conditions"),
              fontSize: AppStyle.small.sp,
              fontWeight: FontWeight.w600,
              color: DMUtil.getDC(),
            ),
            const SizedBox(height: 5,),
            const DotWithTitle(
              title: "medical_conditions",
              titleWidth: 310,
              editFieldWidth: 300,
            ),



            const Divider(height: 30,),

          ],
        );
      },
    );
  }
}