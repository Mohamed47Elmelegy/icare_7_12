import 'package:icare/features/account/presentation/widgets/profile_image_with_action.dart';
import 'package:icare/features/nurse/presentation/widgets/nurse_profile_details_image.dart';
import 'package:icare/features/doctor/presentation/widgets/doctor_profile_details_image.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:flutter/material.dart';

class ProfileCardInfo extends StatelessWidget {
  final String img;
  final String? title;
  final bool enableBackIcon;
  final bool enableEditIcon;
  final bool viewNurseDetails;
  final bool viewDoctorDetails;
  final VoidCallback? backFn;
  const ProfileCardInfo(
      {super.key,
      required this.img,
      required this.title,
      this.enableBackIcon = false,
      this.enableEditIcon = true,
      this.viewNurseDetails = false,
      this.viewDoctorDetails = false,
      this.backFn});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        AppBarWithRadius(
          title: title,
          enableBackIcon: enableBackIcon,
          backFn: backFn,
        ),

        if (viewNurseDetails) ...[
          const NurseProfileDetailsImage(),
        ] else if (viewDoctorDetails) ...[
          const DoctorProfileDetailsImage(),
        ] else ...[
          ProfileImageEdit(
              enableEditIcon: title == null ? false : enableEditIcon, img: img),
        ],

        // if(!viewNurseDetails)
        // Positioned(
        //   right: 10.w,
        //   bottom: 22.w,
        //   child: InkWell(
        //     onTap: ()=> AccountBloc.get(context).add(const EnableUpdateProfileEvent()),
        //     child: const EditIcon(),
        //   ),
        // ),
      ],
    );
  }
}
