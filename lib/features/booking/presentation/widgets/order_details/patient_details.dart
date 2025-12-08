import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/presentation/widgets/gender_row.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

class PatientDetails extends StatelessWidget {
  final Booking item;
  const PatientDetails({super.key,required this.item});

  static final TextEditingController caseDescTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.w,),
      // padding: EdgeInsets.symmetric(vertical: 12.w,horizontal: 5.w),
      decoration: BoxDecoration(
          color: DMUtil.getWC(),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           CustomText(text: item.userName.toString(), fontSize: AppStyle.average.sp,maxLine: 10,),
           const SizedBox(height: 10,),
           Row(
            children: [
              CustomText(
                text: translate("profile.gender"),
                fontSize: AppStyle.small.sp,
                color:  DMUtil.getDC(),
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(width: 15,),

              Row(
                children: [
                  const SelectedCircle(selected: true,selectedColor: kPrimary,),
                  const SizedBox(width: 10,),
                  CustomText(
                    text: item.userGender == 'male' ? translate("profile.male"): translate("profile.female"),
                    fontSize: AppStyle.small.sp,
                  ),
                ],
              ),
            ],
           ),
           const SizedBox(height: 10,),


           
           FutureBuilder(
              future: calcDistance(item.lat,item.lng), 
              builder: (ctx,val){
                if(!val.hasData)return const SizedBox.shrink();
                return Row(
                  children: [
                    CustomText(text: translate("icare.distance"), fontSize: AppStyle.average.sp),
                    const SizedBox(width: 10,),
                    CustomText(text: val.data.toString(), fontSize: AppStyle.average.sp),
                  ],
                );
              },
            ),
            const SizedBox(height: 10,),

            if(Util.isNurse())
            CustomButton(
              height: 24.w,
              width: 114.w,
              widget: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: CustomText(
                  text: translate("order.patient_location"), 
                  fontSize: AppStyle.small.sp-1,
                  color: kPrimary,
                ),
              ),
              sideColor: kPrimary,
              sideWidth: 1,
              color: kWhite, 
              onPressed: ()=> Util.openMapApp(item.lat.toString(),item.lng.toString()),
            ),
        ],
      )
    );
  }

  Future<String> calcDistance(double? lat,double? long)async{
    if(lat==null||long==null||lat==0)return "";
    if(!await Permission.location.serviceStatus.isEnabled)return "";
    Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
    return LocationUtil.calcDistance(
                startLatitude: lat,
                startLongitude: long,
                endLatitude: position.latitude,
                endLongitude: position.longitude);
  }


  
}
