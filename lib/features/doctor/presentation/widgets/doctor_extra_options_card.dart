import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/doctor/presentation/bloc/doctor_state.dart';
import 'package:icare/features/doctor/presentation/bloc/doctors_bloc.dart';
import 'package:icare/features/doctor/presentation/widgets/small_card_doctor_details.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class ExtraDoctorOptionsCard extends StatelessWidget {
  const ExtraDoctorOptionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (ctx, state) {
        var bloc = DoctorBloc.get(ctx);
        var currentDoctor = bloc.currentDoctor;
        if (currentDoctor == null || currentDoctor.userData == null) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: currentDoctor.userData!.userName.toString(),
                  fontWeight: FontWeight.w600,
                  fontSize: AppStyle.small.sp,
                ),
              ],
            ),
            CustomText(
              text: currentDoctor.viewTypeText(),
              fontSize: AppStyle.small.sp,
              color: DMUtil.getD2C(),
            ),
            SizedBox(
              width: 250.w,
              child: CustomText(
                text: currentDoctor.userData!.address.toString(),
                fontSize: AppStyle.small.sp - 1,
                color: DMUtil.getD2C(),
                isEllipsis: true,
                maxLine: 2,
              ),
            ),
            const SizedBox(height: 10),
            const SmallDoctorBoxValues(),
          ],
        );
      },
    );
  }
}

class SmallDoctorBoxValues extends StatelessWidget {
  final bool isRate;
  const SmallDoctorBoxValues({super.key, this.isRate = false});

  @override
  Widget build(BuildContext context) {
    double width = isRate ? 10 : 5;
    return Row(
      mainAxisAlignment: isRate ? MainAxisAlignment.center : MainAxisAlignment.end,
      children: [
        const SmallDoctorProfileCards(title: "10K", subTitle: "patients"),
        SizedBox(width: width.w),
        const SmallDoctorProfileCards(title: "5 years", subTitle: "experience"),
        SizedBox(width: width.w),
        const SmallDoctorProfileCards(title: "5.0", subTitle: "Avg Rating"),
      ],
    );
  }
}
