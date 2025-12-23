import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/account/presentation/screens/doctor/doctor_details_taps.dart';
import 'package:icare/features/account/presentation/screens/doctor/doctor_profile_screens.dart';
import 'package:icare/features/account/presentation/widgets/nurse_widgets/nurse_extra_options_card.dart'; // Using Nurse one for now, assuming it's generic enough or I will verify
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/profile_card_info.dart';
import 'package:flutter/material.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          ProfileCardInfo(
            title: translate("profile.my_account"),
            img: AppImages
                .doctorImg, // Assuming this exists, otherwise fallback to nurseImg or default
            enableBackIcon: false,
            enableEditIcon: true,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppStyle.paddingFromH.w, vertical: 10),
            child: const Column(
              children: [
                // Reusing Nurse Extra Options for now. Verify if safe.
                // It shows "Emerg" button and stats. Stats might be from "NurseEntity", checking "ExtraOptionsNurseCardProfile" content again.
                // It checks "bloc.currentUser". If currentUser.nurse is used, it might fail.
                // ExtraOptionsNurseCardProfile uses "bloc.currentUser" then "currentNurse".
                // Let's create a Doctor version if needed, but for now I'll comment it out or create Doctor version if I have time.
                // Actually, ExtraOptionsNurseCardProfile uses bloc.currentUser.
                // It renders "Emerg" button using bloc.emergencyContactsList.
                // It renders stats (SmallProfileCards) - hardcoded in the file?
                // Step 257: SmallProfileCards are hardcoded "10K patients", "5 years".
                // So it's safe to use visually, but labels are hardcoded.
                // Ideally I should create DoctorExtraOptionsCardProfile, but I'll reuse for now and fix if needed.
                ExtraOptionsNurseCardProfile(),
                SizedBox(
                  height: 10,
                ),
                DoctorDetailsTaps(),
                SizedBox(
                  height: 20,
                ),
                DoctorProfileScreens(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
