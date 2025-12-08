import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_state.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/nurse/presentation/widgets/small_card_nurse_details.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class ExtraOptionsNurseCard extends StatelessWidget {
  const ExtraOptionsNurseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NurseBloc,NurseState>(
      builder: (ctx,state){
        var bloc = NurseBloc.get(ctx);
        var currentNurse = bloc.currentNurse;
        if(currentNurse==null || currentNurse.userData==null)return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: currentNurse.userData!.userName.toString(),
                  fontWeight: FontWeight.w600,
                  fontSize: AppStyle.small.sp,
                ),

                // CustomButton(
                //   height: 25.h,
                //   width: 85.w,
                //   widget: CustomText(
                //     text: translate("nurse.call"),
                //     fontSize: AppStyle.small.sp,
                //     color: DMUtil.getWC(),
                //   ),
                //   color: DMUtil.getPC(),
                //   onPressed: ()=> Util.call("${bloc.currentNurse?.userData!.phoneNumber}"),
                // ),


              ],
            ),
            CustomText(
              text: currentNurse.viewTypeText(),
              fontSize: AppStyle.small.sp,
              color: DMUtil.getD2C(),
            ),
            SizedBox(
              width: 250.w,
              child: CustomText(
                text: currentNurse.userData!.address.toString(),
                fontSize: AppStyle.small.sp-1,
                color: DMUtil.getD2C(),
                isEllipsis: true,
                maxLine: 2,
              ),
            ),

            const SizedBox(height: 10,),

            const SmallNurseBoxValues(),
           
          ],
        );
      },
    );
  }
}



class SmallNurseBoxValues extends StatelessWidget {
  final bool isRate;
  const SmallNurseBoxValues({super.key, this.isRate = false});

  @override
  Widget build(BuildContext context) {
    double width = isRate?10:5;
    return  Row(
      mainAxisAlignment: isRate?MainAxisAlignment.center:MainAxisAlignment.end,
      children:  [
        const SmallProfileCards(title: "10K", subTitle: "patients",),
        SizedBox(width: width.w,),
        const SmallProfileCards(title: "5 years", subTitle: "experience",),
        SizedBox(width: width.w,),
        const SmallProfileCards(title: "5.0", subTitle: "Avg Rating",),
      ],
    );
  }
}
