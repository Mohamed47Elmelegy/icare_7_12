import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/widgets/notifications_widgets/dot_dashed_widget.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/screens/booking_details.dart';
import 'package:icare/features/home/presentation/widgets/request_company/request_details_screen.dart';
import 'package:icare/features/setting/domain/entities/notifications_entity.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class NotificationListCard extends StatelessWidget {
  final NotificationsEntity item;
  const NotificationListCard({super.key,required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        var bloc = BookingBloc.get(context);
        int index = bloc.bookingList.indexWhere((booking) => booking.orderId.toString() == item.orderID.toString());
        if(index==-1)return;
        var booking = bloc.bookingList[index];
        if((item.content.toString().contains("حجز جديد") || item.content.toString().contains("new booking")) && index != -1){
          Util.pushPage(BookingDetailsScreen(item: booking,showActions: !Util.isCustomer() && booking.status == 'PENDING',), context);
        }else{
          Util.pushPage(BookingDetailsScreen(item: booking,), context);
        }
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.circle,color: DMUtil.getRED(),size: 8.w,),
                  const SizedBox(width: 15,),
                  if(item.type=='order')
                  CustomText(
                    text: "${translate("order.code")} ${item.orderID}#",
                    color: DMUtil.getDC(),
                    fontSize: AppStyle.small.sp,
                  ),

                  if(item.type=='request')
                  CustomText(
                    text: translate("home.request"),
                    color: kPrimary,
                    fontSize: AppStyle.small.sp,
                  ),
                ],
              ),
              Row(
                children: [
                  CustomText(
                    text: "${translate("order.ago")} ",
                    fontSize: AppStyle.verySmall.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: "${Util.formatTimeToHMPMorAM(DateTime.parse(item.date))}  -  ${Util.formatToDayMonth(DateTime.parse(item.date))}",
                    // text: Util.calcBetweenTwoDateTime(DateTime.parse(item.date),DateTime.now()),
                    color: DMUtil.getDC().withOpacity(0.6),
                    fontSize: AppStyle.verySmall.sp,
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200.w,
                    child: CustomText(
                      text: item.content.toString(),
                      color: DMUtil.getDC(),
                      fontSize: AppStyle.small.sp,
                      maxLine: 4,
                      isEllipsis: true,
                    ),
                  ),
                  if(item.type=='request')
                  CustomButton(
                    height: 24.w,
                    width: 112.w,
                    widget: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: CustomText(
                        text: translate("home.view_all_offer"), 
                        fontSize: AppStyle.small.sp-2,
                        color: kPrimary,
                      ),
                    ),
                    sideColor: kPrimary,
                    sideWidth: 1,
                    color: kWhite, 
                    onPressed: ()=> Util.pushPage(RequestDetailsScreen(id: item.id.toString(), requestEntity: item.requestEntity),context),
                  ),
                ],
              ),
      
              const SizedBox(height: 10,),
              const DotWidget(),
            ],
          ),
        ],
      ),
    );
  }


}
