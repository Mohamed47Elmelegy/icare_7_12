import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/account/domain/entities/medical_report_entity.dart';

class TodayMonitoringVitals extends StatefulWidget {
  final bool isNurseEditMode;
  final Booking? latestBooking;
  final List<MedicalReportEntity>? selectedDateReports;
  const TodayMonitoringVitals({
    super.key,
    this.isNurseEditMode = false,
    this.latestBooking,
    this.selectedDateReports,
  });

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
    if (widget.isNurseEditMode == true || widget.latestBooking == null) {
      heartRateController = TextEditingController(text: "");
      bloodPressureController = TextEditingController(text: "");
      heightController = TextEditingController(text: "");
      weightController = TextEditingController(text: "");
      pulseRateController = TextEditingController(text: "");
    } else {
      print(
          "DEBUG: TodayMonitoringVitals received latestBooking: ${widget.latestBooking?.orderId}");
      print(
          "DEBUG: Initializing controllers with - HR: ${widget.latestBooking?.heartRate}");

      heartRateController =
          TextEditingController(text: widget.latestBooking?.heartRate ?? "");
      bloodPressureController = TextEditingController(
          text: widget.latestBooking?.bloodPressure ?? "");
      heightController =
          TextEditingController(text: widget.latestBooking?.height ?? "");
      weightController =
          TextEditingController(text: widget.latestBooking?.weight ?? "");
      pulseRateController =
          TextEditingController(text: widget.latestBooking?.pulseRate ?? "");
    }
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
    // Extract historical report values if available
    String? historicalHeartRate;
    String? historicalBloodPressure;
    String? historicalHeight;
    String? historicalWeight;
    String? historicalPulseRate;

    if (widget.selectedDateReports != null &&
        widget.selectedDateReports!.isNotEmpty) {
      final report = widget.selectedDateReports!.first;
      historicalHeartRate = report.heartRate;
      historicalBloodPressure = report.bloodPressure;
      historicalHeight = report.height;
      historicalWeight = report.weight;
      historicalPulseRate = report.pulseRate;
    }

    return Column(
      children: [
        Table(
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
                  historicalValue: historicalHeartRate,
                ),
                VitalsWidget(
                  title: translate("profile.blood_pressure"),
                  controller: bloodPressureController,
                  imgPath: AppImages.bloodPressure,
                  isEditable: widget.isNurseEditMode,
                  historicalValue: historicalBloodPressure,
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
                  historicalValue: historicalHeight,
                ),
                VitalsWidget(
                  title: translate("profile.weight"),
                  controller: weightController,
                  imgPath: AppImages.weight,
                  isEditable: widget.isNurseEditMode,
                  historicalValue: historicalWeight,
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
                  historicalValue: historicalPulseRate,
                ),
                const SizedBox(),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class VitalsWidget extends StatelessWidget {
  final String imgPath;
  final String title;
  final TextEditingController controller;
  final bool isEditable;
  final String? historicalValue;
  const VitalsWidget({
    super.key,
    required this.title,
    required this.controller,
    required this.imgPath,
    this.isEditable = false,
    this.historicalValue,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display current value
                      if (controller.text.isNotEmpty)
                        // CustomText(
                        //   text: controller.text,
                        //   fontSize: AppStyle.small.sp,
                        //   color: DMUtil.getDC(),
                        //   fontWeight: FontWeight.w600,
                        // ),
                        // Display historical value if available and different from current
                        if (historicalValue != null &&
                            historicalValue!.isNotEmpty &&
                            historicalValue != controller.text)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: CustomText(
                              text: historicalValue!,
                              fontSize: AppStyle.small.sp - 1,
                              color: DMUtil.getPC().withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      // If no current value but historical exists
                      if (controller.text.isEmpty &&
                          historicalValue != null &&
                          historicalValue!.isNotEmpty)
                        CustomText(
                          text: historicalValue!,
                          fontSize: AppStyle.small.sp,
                          color: DMUtil.getPC().withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      // If both are empty
                      if (controller.text.isEmpty &&
                          (historicalValue == null || historicalValue!.isEmpty))
                        CustomText(
                          text: "-",
                          fontSize: AppStyle.small.sp,
                          color: DMUtil.getD2C(),
                        ),
                    ],
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
