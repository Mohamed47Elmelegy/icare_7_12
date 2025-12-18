import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/rate_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorCard extends StatelessWidget {
  final UserService doctor;
  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            // Util.pushPage(const CompanyProfile(isProfileView: false), context);
          },
          child: Image.asset(
            AppImages.nurseImg,
            height: 70.h,
            width: 70.w,
            fit: BoxFit.contain,
          ),
        ),
        Expanded(
          flex: 2,
          child: InkWell(
              onTap: () {
                // Util.pushPage(const CompanyProfile(isProfileView: false), context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: doctor.userName.toString(),
                          fontSize: AppStyle.small.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.more_vert,
                            size: 16.w,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 150.w,
                      child: CustomText(
                        text: "Dentist Frisange - 3 km",
                        color: DMUtil.getD2C(),
                        fontSize: AppStyle.small.sp,
                        isEllipsis: true,
                        maxLine: 2,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const RateWidget(),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
