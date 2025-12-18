import 'package:flutter/material.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/nurse/presentation/widgets/personal_screen_widgets/nurse_courses_section.dart';
import 'package:icare/features/nurse/presentation/widgets/personal_screen_widgets/nurse_education_section.dart';
import 'package:icare/features/nurse/presentation/widgets/personal_screen_widgets/nurse_languages_row.dart';
import 'package:icare/features/nurse/presentation/widgets/personal_screen_widgets/nurse_publication_section.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class NurseDetailsPersonalTapScreen extends StatelessWidget {
  const NurseDetailsPersonalTapScreen({super.key});

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
        const SizedBox(
          height: 5,
        ),
        const NurseLanguagesRow(),
        const Divider(),
        CustomText(
          text: translate("nurse.education"),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        const SizedBox(
          height: 5,
        ),
        const NurseEducationSection(),
        const Divider(),
        CustomText(
          text: translate("nurse.experience_year"),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        const SizedBox(
          height: 5,
        ),
        const NursePublicationSection(),
        const Divider(
          height: 15,
        ),
        CustomText(
          text: translate("nurse.courses"),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        const SizedBox(
          height: 5,
        ),
        const NurseCoursesSection(),
        SizedBox(
          height: 80.h,
        ),
      ],
    );
  }
}
