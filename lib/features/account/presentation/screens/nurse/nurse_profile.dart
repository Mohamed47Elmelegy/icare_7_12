import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/account/presentation/screens/nurse/nurse_profile_taps_screens.dart';
import 'package:icare/features/account/presentation/widgets/nurse_widgets/nurse_extra_options_card.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/profile_card_info.dart';
import 'package:flutter/material.dart';
import 'package:icare/features/nurse/presentation/widgets/nurse_details_taps.dart';

class NurseProfileScreen extends StatelessWidget {
  const NurseProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          ProfileCardInfo(
            title: translate("profile.my_account"),
            img: AppImages.nurseImg,
            enableBackIcon: false,
            enableEditIcon: true,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppStyle.paddingFromH.w, vertical: 10),
            child: const Column(
              children: [
                ExtraOptionsNurseCardProfile(),
                SizedBox(
                  height: 10,
                ),
                NurseDetailsTaps(),
                SizedBox(
                  height: 20,
                ),
                NurseProfileScreens(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
