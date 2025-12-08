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
  const NurseBookingAvailableCard({super.key,required this.nurse});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: (){
            // Util.pushPage(const CompanyProfile(isProfileView: false), context);
          },
          child: Image.asset(AppImages.nurseImg,height: 70.h,width: 70.w,fit: BoxFit.contain,),
        ),

        Expanded(
          flex: 2,
          child: InkWell(
            onTap: (){
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
                        text: nurse.userName.toString(),
                        fontSize: AppStyle.small.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                    text: "${translate("nurse.status")}: ",
                                    style: TextStyle(
                                      fontSize: AppStyle.verySmall.sp+1,
                                      color: DMUtil.getGreen(),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: translate("nurse.busy"),
                                        style: TextStyle(
                                          color: DMUtil.getGreen(),
                                          fontSize: AppStyle.verySmall.sp,
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                              CustomText(
                                text: "${translate("nurse.assigned")} lara",
                                fontSize: AppStyle.verySmall.sp,
                                color: DMUtil.getGreen(),
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          SizedBox(width: 10.w,),
                          InkWell(
                            onTap: (){},
                            child: Icon(Icons.more_vert,size: 16.w,),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
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
                  const SizedBox(height: 10,),
                  const RateWidget(),
                ],
              ),
            )
          ),
        ),

      ],
    );
  }
}
