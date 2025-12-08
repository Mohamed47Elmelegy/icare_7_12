import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/dot_with_title.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/row_with_two_title.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ProfileMedicationsTapScreen extends StatelessWidget {
  const ProfileMedicationsTapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: translate("profile.medications"),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        const SizedBox(height: 10,),

        CustomText(
          text: "Aspirin",
          fontSize: AppStyle.verySmall.sp,
          color: DMUtil.getD2C(),
        ),
        SizedBox(height: 3.w,),
        CustomText(
          text: "losartan (ARB)",
          fontSize: AppStyle.verySmall.sp,
          color: DMUtil.getD2C(),
        ),
        SizedBox(height: 3.w,),
        CustomText(
          text: "linagliptin",
          fontSize: AppStyle.verySmall.sp,
          color: DMUtil.getD2C(),
        ),
        const Divider(),
        const SizedBox(height: 10,),
        CustomText(
          text: translate("profile.lab_tests"),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        const SizedBox(height: 5,),
        const RowWithTwoTitle(title1: "Blood Test", title2: "july 18-2017 14:20 Pm"),
        const RowWithTwoTitle(title1: "X Ray", title2: "july 12-2017 20:20 Pm"),

        const Divider(),
        const SizedBox(height: 10,),
        CustomText(
          text: translate("profile.publications"),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        const SizedBox(height: 5,),
        const DotWithTitle(
            title: "publications",
            titleWidth: 310,
        ),
        const SizedBox(height: 100,),
      ],
    );
  }
}



