import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/rate_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class NurseBookingAvailableCard extends StatelessWidget {
  final UserService nurse;
  final bool isBusy;
  final VoidCallback? onTap;

  const NurseBookingAvailableCard({
    super.key,
    required this.nurse,
    this.isBusy = false,
    this.onTap,
  });

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
                if (isBusy) {
                  // Show message that nurse is unavailable with their name
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${translate("nurse.unavailable_booking_message")} ${nurse.userName}',
                      ),
                      backgroundColor: DMUtil.getRED(),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  return;
                }
                if (onTap != null) {
                  onTap!();
                }
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
                          text: nurse.userName.toString(),
                          fontSize: AppStyle.small.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        Row(
                          children: [
                            if (isBusy)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                        text: "${translate("nurse.status")}: ",
                                        style: TextStyle(
                                          fontSize: AppStyle.verySmall.sp + 1,
                                          color: DMUtil.getRED(),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                translate("nurse.unavailable"),
                                            style: TextStyle(
                                              color: DMUtil.getRED(),
                                              fontSize: AppStyle.verySmall.sp,
                                            ),
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                            SizedBox(
                              width: 10.w,
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
