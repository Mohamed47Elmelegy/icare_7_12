import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/widgets/admin_module/main_card_profile.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        CustomText(
          text: translate("admin.dashboard"),
          color: DMUtil.getDC(),
          fontSize: AppStyle.average.sp + 2,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainProfileCard(
                title: translate("admin.appointments"),
                imgPath: AppImages.appointment,
                fn: () {}),
            MainProfileCard(
                title: translate("admin.nurses"),
                imgPath: AppImages.welcomeSecond,
                fn: () {}),
          ],
        ),
        SizedBox(
          height: 20.w,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MainProfileCard(
                title: translate("admin.doctors"),
                imgPath: AppImages.doctor,
                fn: () {}),
            MainProfileCard(
                title: translate("admin.account_settings"),
                imgPath: AppImages.doctor,
                fn: () {}),
          ],
        ),
      ],
    );
  }
}
