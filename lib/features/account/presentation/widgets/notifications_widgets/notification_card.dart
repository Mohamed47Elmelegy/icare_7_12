// import 'package:icare/core/styles/app_style.dart';
// import 'package:icare/core/styles/my_colors.dart';
// import 'package:icare/core/utils/dark_mode_utility.dart';
// import 'package:icare/core/utils/small_fun.dart';
// import 'package:icare/features/account/presentation/widgets/notifications_widgets/dot_dashed_widget.dart';
// import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
// import 'package:icare/features/booking/presentation/screens/booking_details.dart';
// import 'package:icare/features/home/presentation/widgets/request_company/request_details_screen.dart';
// import 'package:icare/features/setting/domain/entities/notifications_entity.dart';
// import 'package:icare/features/shared_widgets/custom_button.dart';
// import 'package:icare/features/shared_widgets/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_translate/flutter_translate.dart';

// class NotificationListCard extends StatelessWidget {
//   final NotificationsEntity item;
//   const NotificationListCard({super.key,required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: (){
//         var bloc = BookingBloc.get(context);
//         int index = bloc.bookingList.indexWhere((booking) => booking.orderId.toString() == item.orderID.toString());
//         if(index==-1)return;
//         var booking = bloc.bookingList[index];
//         if((item.content.toString().contains("حجز جديد") || item.content.toString().contains("new booking")) && index != -1){
//           Util.pushPage(BookingDetailsScreen(item: booking,showActions: !Util.isCustomer() && booking.status == 'PENDING',), context);
//         }else{
//           Util.pushPage(BookingDetailsScreen(item: booking,), context);
//         }
//       },
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.circle,color: DMUtil.getRED(),size: 8.w,),
//                   const SizedBox(width: 15,),
//                   if(item.type=='order')
//                   CustomText(
//                     text: "${translate("order.code")} ${item.orderID}#",
//                     color: DMUtil.getDC(),
//                     fontSize: AppStyle.small.sp,
//                   ),

//                   if(item.type=='request')
//                   CustomText(
//                     text: translate("home.request"),
//                     color: kPrimary,
//                     fontSize: AppStyle.small.sp,
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   CustomText(
//                     text: "${translate("order.ago")} ",
//                     fontSize: AppStyle.verySmall.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   CustomText(
//                     text: "${Util.formatTimeToHMPMorAM(DateTime.parse(item.date))}  -  ${Util.formatToDayMonth(DateTime.parse(item.date))}",
//                     // text: Util.calcBetweenTwoDateTime(DateTime.parse(item.date),DateTime.now()),
//                     color: DMUtil.getDC().withOpacity(0.6),
//                     fontSize: AppStyle.verySmall.sp,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 10,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   SizedBox(
//                     width: 200.w,
//                     child: CustomText(
//                       text: item.content.toString(),
//                       color: DMUtil.getDC(),
//                       fontSize: AppStyle.small.sp,
//                       maxLine: 4,
//                       isEllipsis: true,
//                     ),
//                   ),
//                   if(item.type=='request')
//                   CustomButton(
//                     height: 24.w,
//                     width: 112.w,
//                     widget: Padding(
//                       padding: const EdgeInsets.only(top: 4),
//                       child: CustomText(
//                         text: translate("home.view_all_offer"),
//                         fontSize: AppStyle.small.sp-2,
//                         color: kPrimary,
//                       ),
//                     ),
//                     sideColor: kPrimary,
//                     sideWidth: 1,
//                     color: kWhite,
//                     onPressed: ()=> Util.pushPage(RequestDetailsScreen(id: item.id.toString(), requestEntity: item.requestEntity),context),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 10,),
//               const DotWidget(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

// }
//!
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/booking/presentation/screens/booking_details.dart';
import 'package:icare/features/home/presentation/widgets/request_company/request_details_screen.dart';
import 'package:icare/features/setting/domain/entities/notifications_entity.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class NotificationListCard extends StatelessWidget {
  final NotificationsEntity item;

  const NotificationListCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        // Refresh booking list after successful update or refuse
        if (state is UpdateOrderSuccessfullyState ||
            state is RefuesdOrderSuccessfullyState) {
          // The booking list is already refreshed by the bloc
          // Just trigger a rebuild by getting the updated data
        }
      },
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          var bloc = BookingBloc.get(context);
          var booking = bloc.getBookingByOrderId(item.orderID.toString());

          if (booking == null && item.type == 'order') {
            return const SizedBox.shrink();
          }

          return _buildCard(context, booking);
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, var booking) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: DMUtil.getWC(),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient Info Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Grid
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Patient + Service
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoColumn(
                            label: translate("notification.patient"),
                            value: booking?.userName?.isNotEmpty == true
                                ? booking!.userName!
                                : translate("notification.patient"),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildInfoColumn(
                            label: translate("notification.requested_service"),
                            value: booking?.desc?.isNotEmpty == true
                                ? booking!.desc!
                                : (booking?.type ?? "N/A"),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    // Row 2: Gender + Destination
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoColumn(
                            label: translate("notification.gender"),
                            value: booking?.userGender == 'female'
                                ? translate("profile.female")
                                : translate("profile.male"),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: translate("notification.destination"),
                                color: DMUtil.getD2C().withOpacity(0.5),
                                fontSize: AppStyle.verySmall.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: CustomText(
                                            text: "Far By",
                                            color: DMUtil.getDC(),
                                            fontSize: AppStyle.small.sp + 1,
                                            fontWeight: FontWeight.w600,
                                            maxLine: 1,
                                            isEllipsis: true,
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 12.w,
                                          color:
                                              DMUtil.getD2C().withOpacity(0.6),
                                        ),
                                        SizedBox(width: 2.w),
                                        Flexible(
                                          child: CustomText(
                                            text: "0.8 Km",
                                            color: DMUtil.getD2C()
                                                .withOpacity(0.6),
                                            fontSize: AppStyle.verySmall.sp - 1,
                                            maxLine: 1,
                                            isEllipsis: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  InkWell(
                                    onTap: () {
                                      // TODO: Navigate to map
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6.w, vertical: 3.h),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: DMUtil.getD2C()
                                                .withOpacity(0.3)),
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: CustomText(
                                        text: translate("notification.on_map"),
                                        fontSize: AppStyle.verySmall.sp - 2,
                                        color: DMUtil.getD2C().withOpacity(0.6),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Action Buttons or Status Display
          // Only show accept/refuse buttons for nurses and assistants (not for patients)
          if (booking != null &&
              booking.status == 'PENDING' &&
              !Util.isCustomer()) ...[
            // Show Accept/Refuse buttons only for PENDING bookings and non-customers
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    height: 40.h,
                    color: Colors.green.shade50,
                    circular: 20,
                    onPressed: () {
                      // Trigger accept action using helper method
                      BookingBloc.get(context).acceptOrder(booking);
                    },
                    widget: CustomText(
                      text: translate("notification.accept"),
                      fontSize: AppStyle.average.sp - 2,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                    width: 51.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    height: 40.h,
                    color: Colors.red.shade50,
                    circular: 20,
                    onPressed: () {
                      // Trigger refuse action using helper method
                      BookingBloc.get(context).refuseOrder(booking);
                    },
                    widget: CustomText(
                      text: translate("notification.reject"),
                      fontSize: AppStyle.average.sp - 2,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                    width: 51.w,
                  ),
                ),
              ],
            ),
          ] else if (booking != null &&
              booking.status == 'PENDING' &&
              Util.isCustomer()) ...[
            // For patients with pending bookings, show a simple status message
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hourglass_empty,
                    color: Colors.orange,
                    size: 20.w,
                  ),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: translate("order.pending"),
                    fontSize: AppStyle.average.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ] else if (booking != null && booking.status == 'REFUESD') ...[
            // Show CANCELLED status for refused bookings
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                    size: 20.w,
                  ),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: "تم إلغاء الطلب",
                    fontSize: AppStyle.average.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ] else if (booking != null &&
              (booking.status == 'ONGOING' ||
                  booking.status == 'COMPLETED')) ...[
            // Show status for accepted/ongoing/completed bookings
            InkWell(
              onTap: () {
                Util.pushPage(
                  BookingDetailsScreen(
                    item: booking,
                    showActions: false,
                  ),
                  context,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 20.w,
                    ),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: booking.statusView ?? booking.status ?? "",
                      fontSize: AppStyle.average.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Request-specific View Offers Button
          if (item.type == 'request') ...[
            SizedBox(height: 12.h),
            CustomButton(
              height: 40.h,
              width: double.infinity,
              color: kPrimary,
              circular: 20,
              onPressed: () => Util.pushPage(
                RequestDetailsScreen(
                  id: item.id.toString(),
                  requestEntity: item.requestEntity,
                ),
                context,
              ),
              widget: CustomText(
                text: translate("home.view_all_offer"),
                fontSize: AppStyle.average.sp - 2,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoColumn({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          color: DMUtil.getD2C().withOpacity(0.5),
          fontSize: AppStyle.verySmall.sp,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: value,
          color: DMUtil.getDC(),
          fontSize: AppStyle.small.sp + 1,
          fontWeight: FontWeight.w600,
          maxLine: 1,
          isEllipsis: true,
        ),
      ],
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../../core/utils/dark_mode_utility.dart';
// import '../../../../booking/presentation/bloc/order_bloc.dart';
// import '../../../../booking/presentation/bloc/order_state.dart';
// import '../../../../setting/domain/entities/notifications_entity.dart';
// import 'notification_info_section.dart';
// import 'notification_status_section.dart';

// class NotificationListCard extends StatelessWidget {
//   final NotificationsEntity item;

//   const NotificationListCard({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BookingBloc, BookingState>(
//       builder: (context, state) {
//         final booking = context
//             .read<BookingBloc>()
//             .getBookingByOrderId(item.orderID.toString());

//         if (booking == null && item.type == 'order') {
//           return const SizedBox.shrink();
//         }

//         return Container(
//           margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//           padding: EdgeInsets.all(16.w),
//           decoration: BoxDecoration(
//             color: DMUtil.getWC(),
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//           child: Column(
//             children: [
//               NotificationInfoSection(booking: booking),
//               SizedBox(height: 16.h),
//               NotificationStatusSection(
//                 booking: booking,
//                 notification: item,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
