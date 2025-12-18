import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class PatientDocument extends StatelessWidget {
  const PatientDocument({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: 10.w,
      ),
      padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 5.w),
      decoration: BoxDecoration(
          color: DMUtil.getWC(), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Icon(
            Icons.document_scanner_sharp,
            color: DMUtil.getPC2(),
            size: 21.w,
          ),
          SizedBox(
            width: 5.w,
          ),
          CustomText(
            text: translate("booking.patient_document"),
            fontSize: AppStyle.small.sp,
          ),
        ],
      ),
    );
  }
}
