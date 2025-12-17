import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/today_monitoring_vitals.dart';
import 'package:flutter/material.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';


class ReportTapScreen extends StatelessWidget {
  final bool? isNurseEditMode;
  final GlobalKey<TodayMonitoringVitalsState>? vitalsKey;
  const ReportTapScreen({super.key, this.isNurseEditMode = false, this.vitalsKey});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: translate("profile.medical_conditions"),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        const SizedBox(height: 10,),
        TodayMonitoringVitals(
          key: vitalsKey,
          isNurseEditMode: isNurseEditMode ?? false,
        ),

        const SizedBox(height: 10,),
        CustomText(
          text: translate("profile.reports_history"),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        const SizedBox(height: 10,),
        InkWell(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: DMUtil.getWC()
            ),
            child: Row(
              children: [
                Icon(Icons.date_range,color: DMUtil.getPC2(),),
                const SizedBox(width: 5,),
                CustomText(
                    text: translate("order.by_date"),
                    fontSize: AppStyle.small.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}