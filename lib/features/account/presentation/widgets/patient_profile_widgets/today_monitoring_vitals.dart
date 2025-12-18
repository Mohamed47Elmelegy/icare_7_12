import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';

class TodayMonitoringVitals extends StatefulWidget {
  final bool isNurseEditMode;
  const TodayMonitoringVitals({super.key, this.isNurseEditMode = false});

  @override
  State<TodayMonitoringVitals> createState() => TodayMonitoringVitalsState();
}

class TodayMonitoringVitalsState extends State<TodayMonitoringVitals> {
  late TextEditingController heartRateController;
  late TextEditingController bloodPressureController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController pulseRateController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with default values
    heartRateController = TextEditingController(text: "56");
    bloodPressureController = TextEditingController(text: "120/80");
    heightController = TextEditingController(text: "5'7''ft");
    weightController = TextEditingController(text: "135");
    pulseRateController = TextEditingController(text: "135");
  }

  @override
  void dispose() {
    heartRateController.dispose();
    bloodPressureController.dispose();
    heightController.dispose();
    weightController.dispose();
    pulseRateController.dispose();
    super.dispose();
  }

  // Method to get all vital values for saving
  Map<String, String> getVitalValues() {
    return {
      'heart_rate': heartRateController.text,
      'blood_pressure': bloodPressureController.text,
      'height': heightController.text,
      'weight': weightController.text,
      'pulse_rate': pulseRateController.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200.w,
          child: Table(
            border: TableBorder.all(
              color: DMUtil.getD2C().withOpacity(0.4),
            ),
            children: [
              TableRow(
                children: [
                  VitalsWidget(
                    title: translate("profile.heart_rate"),
                    controller: heartRateController,
                    imgPath: AppImages.heartRate,
                    isEditable: widget.isNurseEditMode,
                  ),
                  VitalsWidget(
                    title: translate("profile.blood_pressure"),
                    controller: bloodPressureController,
                    imgPath: AppImages.bloodPressure,
                    isEditable: widget.isNurseEditMode,
                  ),
                ],
              ),
              TableRow(
                children: [
                  VitalsWidget(
                    title: translate("profile.height"),
                    controller: heightController,
                    imgPath: AppImages.height,
                    isEditable: widget.isNurseEditMode,
                  ),
                  VitalsWidget(
                    title: translate("profile.weight"),
                    controller: weightController,
                    imgPath: AppImages.weight,
                    isEditable: widget.isNurseEditMode,
                  ),
                ],
              ),
              TableRow(
                children: [
                  VitalsWidget(
                    title: translate("profile.pulse_rate"),
                    controller: pulseRateController,
                    imgPath: AppImages.pulseRate,
                    isEditable: widget.isNurseEditMode,
                  ),
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
  final TextEditingController controller;
  final bool isEditable;
  const VitalsWidget({
    super.key,
    required this.title,
    required this.controller,
    required this.imgPath,
    this.isEditable = false,
  });

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
          const SizedBox(
            width: 6,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isEditable)
                  TextField(
                    controller: controller,
                    style: TextStyle(
                      fontSize: AppStyle.small.sp,
                      color: DMUtil.getDC(),
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: DMUtil.getD2C().withOpacity(0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: DMUtil.getD2C().withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: DMUtil.getPC(),
                          width: 1.5,
                        ),
                      ),
                    ),
                  )
                else
                  CustomText(
                    text: controller.text,
                    fontSize: AppStyle.small.sp,
                  ),
                const SizedBox(
                  height: 4,
                ),
                CustomText(
                  text: title,
                  fontSize: AppStyle.small.sp - 2,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
