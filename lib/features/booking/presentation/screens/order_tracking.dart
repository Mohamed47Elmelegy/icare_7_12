import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/strings/enum/order_enum.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/booking/data/models/order_model.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/presentation/widgets/order_tracking_widgets/order_card_details.dart';
import 'package:icare/features/booking/presentation/widgets/order_tracking_widgets/tracking_line.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Booking item;
  const OrderTrackingScreen({super.key,required this.item});

  @override
  Widget build(BuildContext context) {
    ORDER_STATUS status  = OrderModel.getStatusViewCheck(item.status.toString());
    return Scaffold(
      backgroundColor: DMUtil.getWC(),
      appBar: GlobalAppBar(
        title: translate("order.track_location"),
        leadingIcon: const BackArrowButton(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderCardDetails(item: item,isTrack: true),
            const SizedBox(height: 10,),

            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppImages.orderStep1,colorFilter: ColorFilter.mode(status==ORDER_STATUS.PENDING?DMUtil.getRED():DMUtil.getREdOPACITY(), BlendMode.srcIn),),
                  const SmallRowDots(),
                  Icon(Icons.directions_bus,color: status==ORDER_STATUS.ONGOING?DMUtil.getRED():DMUtil.getREdOPACITY(),size: 25.w,),
                  // SvgPicture.asset(AppImages.orderStep2, colorFilter: ColorFilter.mode(status==ORDER_STATUS.COMPLETED?DMUtil.getRED():DMUtil.getREdOPACITY(), BlendMode.color),),
                  const SmallRowDots(),
                  SvgPicture.asset(AppImages.orderStep3,colorFilter: ColorFilter.mode(status==ORDER_STATUS.COMPLETED?DMUtil.getRED():DMUtil.getREdOPACITY(), BlendMode.srcIn),),
                ],
              ),
            ),

            const SizedBox(height: 10,),

            TrackingLineWidget(status: status,),


            const SizedBox(height: 30,),

          ],
        ),
      ),
    );
  }
}


class SmallRowDots extends StatelessWidget {
  const SmallRowDots({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Text("------------------------------------------------------",style: TextStyle(color: DMUtil.getRED()),maxLines: 1,),
    );
  }
}

