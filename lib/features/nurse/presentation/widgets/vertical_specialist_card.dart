import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_event.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/nurse/presentation/screens/nurse_details_screen.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/global_app_image.dart';
import 'package:icare/features/shared_widgets/review.dart';

class VerticalSpecialistCard extends StatelessWidget {
  final NurseEntity nurse;
  const VerticalSpecialistCard({super.key,required this.nurse,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(){
        NurseBloc.get(context).add(UpdateCurrentNurseEvent(nurse: nurse));
        Util.pushPage(const NurseDetails(), context);
      },
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const SizedBox(width: 5,),
                  ImageWidget(imgUrl: nurse.userData!.image.toString(),width: 60,height: 60,fit: BoxFit.fill,errorImg: AppImages.nurse,radius: 50,),
                  const SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: nurse.viewTypeText(),
                        color: DMUtil.getText(),
                        fontSize: AppStyle.small.sp-1,
                      ),
                      const SizedBox(height: 5,),
                      SizedBox(
                        width: 120.w,
                        child: CustomText(
                          text: nurse.userData!.userName.toString(),
                          color: DMUtil.getText(),
                          fontSize: AppStyle.average.sp-2,
                          isEllipsis: true,
                        ),
                      ),
      
                      ReviewsWidget(amount: 200, color: DMUtil.getBookButtonColor()),
      
                    ],
                  ),
                ],
              ),
              SizedBox(width: 24.w,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    text: LocationUtil.getDistanceView(nurse.distanceKM, nurse.distanceM), 
                    color: DMUtil.getText(),
                    fontSize: AppStyle.small.sp-1,
                  ),
                  const SizedBox(height: 10,),
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
                    onPressed: (){
                      NurseBloc.get(context).add(UpdateCurrentNurseEvent(nurse: nurse));
                      Util.pushPage(const NurseDetails(), context);
                    },
                  ),
                ],
              ),
              
              const SizedBox(width: 5,),
            ],
          ),
        )
      ),
    );
  }
}
