import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/features/doctor/presentation/bloc/doctor_state.dart';
import 'package:icare/features/doctor/presentation/bloc/doctors_bloc.dart';

class DoctorProfileDetailsImage extends StatelessWidget {
  final bool isTopPadding;
  const DoctorProfileDetailsImage({super.key, this.isTopPadding = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: isTopPadding ? 132.w : 0,
          bottom: isTopPadding == false ? 230.w : 0),
      child: BlocBuilder<DoctorBloc, DoctorState>(
        builder: (ctx, state) {
          var bloc = DoctorBloc.get(ctx);
          var currentDoctor = bloc.currentDoctor;
          if (currentDoctor == null || currentDoctor.userData == null) {
            return const SizedBox.shrink();
          }
          String img = currentDoctor.userData!.image.toString();
          if (img.trim() == "") {
            return CircleAvatar(
              radius: 50.w,
              backgroundColor: Colors.transparent,
              backgroundImage: const AssetImage(AppImages.doctorImg),
            );
          }
          return CircleAvatar(
            radius: 50.w,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(img),
          );
        },
      ),
    );
  }
}
