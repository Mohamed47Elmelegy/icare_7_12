import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/dot_with_title.dart';
import 'package:flutter/material.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/doctor/presentation/bloc/doctor_state.dart';
import 'package:icare/features/doctor/presentation/bloc/doctors_bloc.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/shared_widgets/rate_widget.dart';
import 'package:icare/features/shared_widgets/review.dart';

class DoctorDetailsFeedBacksTapScreen extends StatelessWidget {
  const DoctorDetailsFeedBacksTapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: translate("icare.rate"),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        const RateWidget(),
        const Divider(height: 10),
        BlocBuilder<DoctorBloc, DoctorState>(
          builder: (ctx, state) {
            var bloc = DoctorBloc.get(ctx);
            var doctor = bloc.currentDoctor;
            if (doctor == null || doctor.reviewList == null) {
              return const SizedBox.shrink();
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              itemCount: doctor.reviewList!.length,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              separatorBuilder: (ctx, index) => const SizedBox(height: 10),
              itemBuilder: (ctx, index) {
                var item = doctor.reviewList![index];
                return Card(
                  margin: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DotWithTitleView(
                          title: item.txt.toString(),
                          titleWidth: 240,
                        ),
                        ReviewWidgetView(rate: item.ratingValue ?? 1),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
