import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';

class TodayMonitoringVitals extends StatelessWidget {
  const TodayMonitoringVitals({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        SizedBox(
          height: 200.w,
          child: Table(
            border: TableBorder.all(color: DMUtil.getD2C().withOpacity(0.4),),
            children: [
              TableRow(
                children : [
                  VitalsWidget(title: translate("profile.heart_rate"), value: "56", imgPath: AppImages.heartRate),
                  VitalsWidget(title: translate("profile.blood_pressure"), value: "120/80", imgPath: AppImages.bloodPressure),
                ],
              ),
              TableRow(
                children : [
                  VitalsWidget(title: translate("profile.height"), value: "5’7’’ft", imgPath: AppImages.height),
                  VitalsWidget(title: translate("profile.weight"), value: "135", imgPath: AppImages.weight),
                ],
              ),
              TableRow(
                children : [
                  VitalsWidget(title: translate("profile.pulse_rate"), value: "135", imgPath: AppImages.pulseRate),
                  const SizedBox(),
                ],
              ),
            ],
          ),
        )


        
      ],
    );
  }
}


class VitalsWidget extends StatelessWidget {
  final String imgPath;
  final String title;
  final String value;
  const VitalsWidget({super.key,required this.title,required this.value,required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          SvgPicture.asset(
            imgPath,
            width: 30.w,
          ),
          const SizedBox(width: 6,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: value,
                fontSize: AppStyle.small.sp,
              ),
              const SizedBox(height: 4,),
              CustomText(
                text: title,
                fontSize: AppStyle.small.sp-2,
              ),
            ],
          )
        ],
      ),
    );
  }
}
