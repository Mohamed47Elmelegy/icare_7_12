import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/locations/domain/entities/location_entity.dart';
import 'package:icare/features/locations/presentation/screens/my_locations.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:icare/features/locations/presentation/bloc/locations_state.dart';

class SelectLocations extends StatelessWidget {
  const SelectLocations({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationsBloc,LocationsState>(
      builder: (ctx,state){
        var bloc = LocationsBloc.get(ctx);
        List<LocationEntity> list = [];
        var location  = bloc.userLocationsList;
        if(location!=null&&location.shippingAddress!=null)list.add(location.shippingAddress!);
        if(location!=null&&location.billingAddress!=null)list.add(location.billingAddress!);
        bloc.currentCheckOutLocation ??= list.first;
        if(list.isEmpty)return const SizedBox.shrink();
        return Container(
            color: DMUtil.getWC(),
            child: InkWell(
              onTap: ()=> Util.pushPage(const MyLocationsScreen(), context),
              child: Container(
                height: 30.h,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  color: DMUtil.getBackGround(),
                  boxShadow: DMUtil.currentThemeIsDark()?  const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0, // soften the shadow
                      spreadRadius: 0.7, //extend the shadow
                      offset: Offset(
                        0.01, // Move to right 10  horizontally
                        0.01, // Move to bottom 10 Vertically
                      ),
                    )
                  ]:const [],
                ),
                margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 10,),
                        Icon(Icons.location_on_outlined,color: DMUtil.getD2C().withOpacity(0.7),size: AppStyle.average.w+1,),
                        const SizedBox(width: 5,),
                        Row(
                          children: [
                            CustomText(
                              text: "${translate("store.deliver_to")} ",
                              color: DMUtil.getDC(),
                              fontSize: AppStyle.small.sp-1,
                            ),
                            CustomText(
                              text: "${bloc.currentCheckOutLocation?.address1}",
                              color: DMUtil.getD2C(),
                              fontSize: AppStyle.small.sp,
                              fontWeight: FontWeight.w600,
                              isEllipsis: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_drop_down,color: DMUtil.getD2C(),size: AppStyle.average.w,),
                    ),
                  ],
                ),
                // child: DropdownButton(
                //   isExpanded: true,
                //   padding: EdgeInsets.zero,
                //   dropdownColor: DMUtil.getWC(),
                //   alignment: Alignment.center,
                //   onTap: ()=> Util.pushPage(const MyLocationsScreen(), context),
                //   underline: const SizedBox.shrink(),
                //   style: TextStyle(color: DMUtil.getDC(), fontSize: AppStyle.small.sp,fontFamily: primaryFontReg),
                //   hint: Row(
                //     children: [
                //       const SizedBox(width: 10,),
                //       Icon(Icons.location_on_outlined,color: DMUtil.getD2C().withOpacity(0.7),size: AppStyle.average.w,),
                //       const SizedBox(width: 5,),
                //       CustomText(
                //         text: "${translate("store.deliver_to")} ${bloc.currentCheckOutLocation?.address1}",
                //         color: DMUtil.getDC(),
                //         fontSize: AppStyle.small.sp,
                //         isEllipsis: true,
                //       ),
                //     ],
                //   ),
                //   onChanged: (val)=> Util.pushPage(const MyLocationsScreen(), context),
                //   icon: Icon(Icons.keyboard_arrow_down_outlined,color: DMUtil.getDC(),),
                //   items: list.map((e) => DropdownMenuItem(
                //     value: e,
                //     child: Row(
                //       children: [
                //         const SizedBox(width: 10,),
                //         Icon(Icons.location_on_outlined,color: DMUtil.getD2C().withOpacity(0.7),size: AppStyle.average.w,),
                //         const SizedBox(width: 5,),
                //         CustomText(
                //           text: "${translate("store.deliver_to")} ${bloc.currentCheckOutLocation?.address1}",
                //           color: DMUtil.getDC(),
                //           fontSize: AppStyle.small.sp,
                //           isEllipsis: true,
                //         ),
                //       ],
                //     ),
                //   )).toList(),
                //   value: bloc.currentCheckOutLocation,
                // ),
              ),
            )
        );
      },
    );
  }

}
