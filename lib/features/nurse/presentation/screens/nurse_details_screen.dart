import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/profile_card_info.dart';
import 'package:flutter/material.dart';
import 'package:icare/features/nurse/presentation/screens/nurse_details_taps_screens.dart';
import 'package:icare/features/nurse/presentation/widgets/nurse_details_taps.dart';
import 'package:icare/features/nurse/presentation/widgets/nurse_extra_options_card.dart';
import 'package:icare/features/nurse/presentation/widgets/request_button.dart';

class NurseDetails extends StatelessWidget {
  const NurseDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const RequestButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const ProfileCardInfo(
              title: "",
              img: AppImages.nurseImg,
              enableBackIcon: true,
              enableEditIcon: false,
              viewNurseDetails: true,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppStyle.paddingFromH.w, vertical: 10),
              child: const Column(
                children: [
                  ExtraOptionsNurseCard(),
                  SizedBox(
                    height: 10,
                  ),
                  NurseDetailsTaps(),
                  SizedBox(
                    height: 20,
                  ),
                  NurseDetailsScreens(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
