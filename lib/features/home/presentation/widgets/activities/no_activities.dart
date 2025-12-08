import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/nurse/presentation/screens/vertical_specialists_list.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class NoActivitiesWidget extends StatelessWidget {
  const NoActivitiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomText(
            text: translate("icare.not_activities"),
            fontWeight: FontWeight.w600,
            fontSize: AppStyle.small.sp,
        ),

        const SizedBox(width: 5,),
        InkWell(
          onTap: ()=> Util.pushPage(const AllSpecialistsScreen(), context),
          child: Row(
            children: [
              CustomText(
                text: translate("icare.new_appointment"),
                fontWeight: FontWeight.w600,
                fontSize: AppStyle.small.sp,
                color: DMUtil.getPC(),
              ),
              Icon(Icons.add,color: DMUtil.getPC(),),
            ],
          ),
        ),
      ],
    );
  }
}
