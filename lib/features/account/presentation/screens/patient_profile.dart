import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/profile_card_info.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/profile_taps.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/profile_taps_screens.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/today_monitoring_vitals.dart';
import 'package:flutter/material.dart';

class PatientProfile extends StatelessWidget {
  final bool isNurseEditMode;
  final VoidCallback? fnAfterNurseEdit;
  final GlobalKey<TodayMonitoringVitalsState>? vitalsKey;
  const PatientProfile({
    super.key,
    this.isNurseEditMode = false,
    this.fnAfterNurseEdit,
    this.vitalsKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileCardInfo(
          title:
              isNurseEditMode == true ? null : translate("profile.my_account"),
          img: AppImages.avatar,
          backFn: fnAfterNurseEdit,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppStyle.paddingFromH.w, vertical: 10),
          child: Column(
            children: [
              const ProfileTaps(),
              const SizedBox(
                height: 20,
              ),
              ProfileTapsScreens(
                isNurseEditMode: isNurseEditMode,
                vitalsKey: vitalsKey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
