import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/profile_card_info.dart';

class NurseTracking extends StatelessWidget {
  const NurseTracking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const ProfileCardInfo(title: "",img: AppImages.nurseImg,enableBackIcon: true,enableEditIcon: false,viewNurseDetails: true,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w,vertical: 10),
              child: const Column(
                children: [

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
