// ignore_for_file: use_build_context_synchronously
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';

import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/booking/presentation/screens/booking_details.dart';
import 'package:icare/features/booking/presentation/widgets/booking_row_actions.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';


class OrderCardDetails extends StatelessWidget {
  final bool enableTracking;
  final Booking item;
  final bool isTrack;
  const OrderCardDetails({super.key,this.enableTracking = false,required this.item,this.isTrack = false});

  @override
  Widget build(BuildContext context) {
    var list = NurseBloc.get(context).nursesList;
    int index = list.indexWhere((element) => item.nurseID==element.id);
    if(index==-1 || item.userId==null)return const SizedBox.shrink();
    var orderNurse = list[index];
    return InkWell(
      onTap: ()=> Util.pushPage(BookingDetailsScreen(item: item),context),
      child: Container(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "${translate("order.date")} ${Util.formatToDayFullMonthYear(DateTime.parse(item.date.toString()))}",
                  color: DMUtil.getD2C(),
                  fontSize: AppStyle.small.sp+1,
                ),
                CustomText(
                  text: "#${item.orderId}",
                  color: DMUtil.getD2C(),
                  fontWeight: FontWeight.w600,
                  fontSize: AppStyle.small.sp+2,
                ),
      
              ],
            ),
            const SizedBox(height: 5,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: Util.isCustomer()? "${item.nurseName}" : "${item.userName}",
                      color: DMUtil.getDC(),
                      fontWeight: FontWeight.w600,
                      fontSize: AppStyle.small.sp-3,
                      isEllipsis: true,
                    ),
                    if(!Util.isCustomer())...[
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 250.w,
                        child: CustomText(
                          text: item.desc.toString().trim(),
                          color: DMUtil.getD2C(),
                          fontSize: AppStyle.verySmall.sp-2,
                          maxLine: 4,
                        ),
                      ),
                    ],
                  ],
                ),
      
                BookingRowActions(item: item, orderNurse: orderNurse),
              ],
            ),
            const Divider(height: 10,),
          ],
        ),
      ),
    );
  }

}
