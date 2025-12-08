import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/locations/domain/entities/location_entity.dart';
import 'package:icare/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:icare/features/locations/presentation/bloc/locations_event.dart';
import 'package:icare/features/locations/presentation/bloc/locations_state.dart';
import 'package:icare/features/locations/presentation/screens/set_and_get_coordinates.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class CurrentLocationDetails extends StatelessWidget {
  const CurrentLocationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationsBloc,LocationsState>(
      builder: (ctx,state){
        var bloc = LocationsBloc.get(ctx);
        return InkWell(
          onTap: ()async{
            final res = await Util.pushPage(MapScreen(isSet: false, title: translate("toast.select_location")), context);
            if(res != null){
              bloc.add(UpdateCurrentLocationEvent(location: LocationEntity(
                  address1: res.address, address2: res.address,
                  country: res.address, phone: res.address, id: 1,
                  type: "auth", long: res.long, lat: res.lat,
                  state: res.city, firstName: "",
                  lastName: "", email: "",
                  postCode: res.postalCode)));
            }
          },
          child: Container(
              height: 47.h,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: DMUtil.getWC(),
                  border: Border.all(width: 1,color:  DMUtil.getOpacity())
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 250.w,
                        child: CustomText(
                          text: bloc.currentCheckOutLocation!=null? " ${bloc.currentCheckOutLocation?.address1} ${bloc.currentCheckOutLocation?.address2}" : translate("toast.select_location"),
                          fontSize: AppStyle.small.sp,
                          color: DMUtil.getPC2().withOpacity(0.9),
                          isEllipsis: true,
                        ),
                      ),
                      const SizedBox(height: 4,),
                      CustomText(
                        text: translate("map.directions"),
                        fontSize: AppStyle.small.sp-1,
                        color: DMUtil.getD2C(),
                      ),
                    ],
                  ),

                  Icon(Icons.location_on,size: 18.w,color: DMUtil.getD2C(),),
                ],
              )
          ),
        );
      },
    );
  }
}
