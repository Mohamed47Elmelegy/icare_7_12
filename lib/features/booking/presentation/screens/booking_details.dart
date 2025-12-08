import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/presentation/widgets/nurse/request_actions.dart';
import 'package:icare/features/booking/presentation/widgets/order_details/order_description.dart';
import 'package:icare/features/booking/presentation/widgets/order_details/patient_details.dart';
import 'package:icare/features/shared_widgets/align_child_by_row.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:flutter/material.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Booking item;
  final bool showActions;
  const BookingDetailsScreen({super.key,required this.item,this.showActions = false});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DMUtil.getPC(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !showActions ? const SizedBox.shrink() : RequestActions(item: item),
      appBar: GlobalAppBar(
          backGroundColor: DMUtil.getPC(),
          title: item.statusView.toString(),
          textColor: DMUtil.getWC(),
          // leadingIcon: DrawerIcon(ctx: context,color: DMUtil.getWC(),),
          leadingIcon: BackArrowButton(color: DMUtil.getWC(),),
      ),
      body: Container(
        padding: AppStyle.globalPadding,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
            color: DMUtil.getWC(),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
        ),
        child:  SingleChildScrollView(
          physics: const  BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start  ,
            children: [

              AlignChildRow(
                isStart: false,
                child: Row(
                  children: [
                    CustomText(
                      text: Util.formatToDayMonth(DateTime.parse(item.date.toString())), 
                      fontSize: AppStyle.average.sp
                    ),
                    const SizedBox(width: 10,),
                    CustomText(
                      text: "-    #${item.orderId}", 
                      fontSize: AppStyle.average.sp
                    ),
                  ],
                ),
              ),

              PatientDetails(item: item,),


              const Divider(height: 30,),
              RequestDetails(txt: item.desc.toString()),

             
            ],
          ),
        ),
      ),
    );
  }
}
