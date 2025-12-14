import 'package:flutter/material.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/doctor/presentation/widgets/personal_screen_widgets/doctor_courses_section.dart';
import 'package:icare/features/doctor/presentation/widgets/personal_screen_widgets/doctor_education_section.dart';
import 'package:icare/features/doctor/presentation/widgets/personal_screen_widgets/doctor_languages_row.dart';
import 'package:icare/features/doctor/presentation/widgets/personal_screen_widgets/doctor_publication_section.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class DoctorDetailsPersonalTapScreen extends StatelessWidget {
  const DoctorDetailsPersonalTapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: translate("profile.lang"),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        const SizedBox(height: 5),
        const DoctorLanguagesRow(),
        const Divider(),
        CustomText(
          text: translate("doctor.education"),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        const SizedBox(height: 5),
        const DoctorEducationSection(),
        const Divider(),
        CustomText(
          text: translate("doctor.experience_year"),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        const SizedBox(height: 5),
        const DoctorPublicationSection(),
        const Divider(height: 15),
        CustomText(
          text: translate("doctor.courses"),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        const SizedBox(height: 5),
        const DoctorCoursesSection(),
        SizedBox(height: 80.h),
      ],
    );
  }
}
