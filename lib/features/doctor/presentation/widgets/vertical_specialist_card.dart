import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/doctor/domain/entities/doctor_entity.dart';
import 'package:icare/features/doctor/presentation/bloc/doctor_event.dart';
import 'package:icare/features/doctor/presentation/bloc/doctors_bloc.dart';
import 'package:icare/features/doctor/presentation/screens/doctor_details_screen.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/global_app_image.dart';
import 'package:icare/features/shared_widgets/review.dart';

class VerticalDoctorSpecialistCard extends StatelessWidget {
  final DoctorEntity doctor;
  const VerticalDoctorSpecialistCard({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        DoctorBloc.get(context).add(UpdateCurrentDoctorEvent(doctor: doctor));
        Util.pushPage(const DoctorDetails(), context);
      },
      child: Card(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const SizedBox(width: 5),
                    ImageWidget(
                      imgUrl: doctor.userData!.image.toString(),
                      width: 60,
                      height: 60,
                      fit: BoxFit.fill,
                      errorImg: AppImages.doctor,
                      radius: 50,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: doctor.viewTypeText(),
                            color: DMUtil.getText(),
                            fontSize: AppStyle.small.sp - 1,
                          ),
                          const SizedBox(height: 5),
                          CustomText(
                            text: doctor.userData!.userName.toString(),
                            color: DMUtil.getText(),
                            fontSize: AppStyle.average.sp - 2,
                            isEllipsis: true,
                            maxLine: 1,
                          ),
                          ReviewsWidget(amount: 200, color: DMUtil.getBookButtonColor()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    text: LocationUtil.getDistanceView(doctor.distanceKM, doctor.distanceM),
                    color: DMUtil.getText(),
                    fontSize: AppStyle.small.sp - 1,
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    height: 24.h,
                    width: 74.w,
                    circular: 8,
                    sideColor: DMUtil.getBookButtonColor(),
                    sideWidth: 1,
                    widget: CustomText(
                      text: translate("booking.book"),
                      fontSize: AppStyle.small.sp,
                      color: DMUtil.getBookButtonColor(),
                      alignCenter: true,
                    ),
                    color: DMUtil.getWC(),
                    onPressed: () {
                      DoctorBloc.get(context).add(UpdateCurrentDoctorEvent(doctor: doctor));
                      Util.pushPage(const DoctorDetails(), context);
                    },
                  ),
                ],
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}
