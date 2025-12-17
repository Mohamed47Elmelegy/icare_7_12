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
  const BookingDetailsScreen(
      {super.key, required this.item, this.showActions = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DMUtil.getPC(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          !showActions ? const SizedBox.shrink() : RequestActions(item: item),
      appBar: GlobalAppBar(
        backGroundColor: DMUtil.getPC(),
        title: item.statusView.toString(),
        textColor: DMUtil.getWC(),
        // leadingIcon: DrawerIcon(ctx: context,color: DMUtil.getWC(),),
        leadingIcon: BackArrowButton(
          color: DMUtil.getWC(),
        ),
      ),
      body: Container(
        padding: AppStyle.globalPadding,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
            color: DMUtil.getWC(),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AlignChildRow(
                isStart: false,
                child: Row(
                  children: [
                    CustomText(
                        text: Util.formatToDayMonth(
                            DateTime.parse(item.date.toString())),
                        fontSize: AppStyle.average.sp),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomText(
                        text: "-    #${item.orderId}",
                        fontSize: AppStyle.average.sp),
                  ],
                ),
              ),
              PatientDetails(
                item: item,
              ),
              const Divider(
                height: 30,
              ),
              RequestDetails(txt: item.desc.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
//! //?////////////////////////////////////
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import 'package:icare/core/styles/app_style.dart';
// import 'package:icare/core/utils/dark_mode_utility.dart';
// import 'package:icare/core/utils/small_fun.dart';
// import 'package:icare/features/booking/domain/entities/order.dart';
// import 'package:icare/features/booking/presentation/widgets/nurse/request_actions.dart';
// import 'package:icare/features/shared_widgets/custom_text.dart';
// import 'package:icare/features/shared_widgets/global_widgets.dart';

// class BookingDetailsScreen extends StatelessWidget {
//   final Booking item;
//   final bool showActions;

//   const BookingDetailsScreen({
//     super.key,
//     required this.item,
//     this.showActions = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: DMUtil.getWC(),
//       appBar: AppBar(
//         backgroundColor: DMUtil.getWC(),
//         elevation: 0,
//         leading: BackArrowButton(color: DMUtil.getDC()),
//         title: CustomText(
//           text: translate("booking.booking_details"),
//           fontSize: AppStyle.large.sp,
//           fontWeight: FontWeight.w600,
//           color: DMUtil.getDC(),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             // Header Card with Image
//             Container(
//               margin: EdgeInsets.all(16.w),
//               decoration: BoxDecoration(
//                 color: DMUtil.getWC(),
//                 borderRadius: BorderRadius.circular(16.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   // Profile Image Section
//                   Container(
//                     width: double.infinity,
//                     height: 200.h,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(16.r),
//                         topRight: Radius.circular(16.r),
//                       ),
//                       image: item.userData?.image != null &&
//                               item.userData!.image!.isNotEmpty
//                           ? DecorationImage(
//                               image: NetworkImage(item.userData!.image!),
//                               fit: BoxFit.cover,
//                             )
//                           : null,
//                     ),
//                     child: item.userData?.image == null ||
//                             item.userData!.image!.isEmpty
//                         ? Icon(
//                             Icons.person,
//                             size: 80.w,
//                             color: Colors.grey.shade400,
//                           )
//                         : null,
//                   ),

//                   Padding(
//                     padding: EdgeInsets.all(16.w),
//                     child: Column(
//                       children: [
//                         // Patient Info Grid
//                         _buildInfoRow(
//                           label1: translate("booking.patient"),
//                           value1: item.userName ?? "N/A",
//                           label2: "",
//                           value2: "",
//                         ),

//                         SizedBox(height: 16.h),

//                         Row(
//                           children: [
//                             Expanded(
//                               child: _buildInfoColumn(
//                                 label: translate("booking.gender"),
//                                 value: item.userGender == 'female'
//                                     ? translate("profile.female")
//                                     : translate("profile.male"),
//                               ),
//                             ),
//                             SizedBox(width: 16.w),
//                             Expanded(
//                               child: _buildInfoColumn(
//                                 label: translate("booking.mobile"),
//                                 value: item.userData?.phoneNumber ??
//                                     "+123 456 789 234",
//                               ),
//                             ),
//                           ],
//                         ),

//                         SizedBox(height: 16.h),

//                         _buildInfoColumn(
//                           label: translate("booking.address"),
//                           value: item.shippingAddress ??
//                               "2 Rue de Ermesinde\nFrisange - Luxembourg 3 km",
//                           isFullWidth: true,
//                         ),

//                         SizedBox(height: 16.h),

//                         Row(
//                           children: [
//                             Expanded(
//                               child: _buildInfoColumn(
//                                 label: translate("booking.destination"),
//                                 value:
//                                     "${item.distanceKM?.toStringAsFixed(1) ?? '0.8'} Km",
//                               ),
//                             ),
//                             SizedBox(width: 8.w),
//                             InkWell(
//                               onTap: () {
//                                 // TODO: Navigate to map
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 12.w, vertical: 8.h),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                       color: DMUtil.getD2C().withOpacity(0.3)),
//                                   borderRadius: BorderRadius.circular(20.r),
//                                 ),
//                                 child: CustomText(
//                                   text: translate("booking.map"),
//                                   fontSize: AppStyle.small.sp,
//                                   color: DMUtil.getDC(),
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         SizedBox(height: 16.h),

//                         Row(
//                           children: [
//                             Expanded(
//                               child: _buildInfoColumn(
//                                 label: translate("booking.requested_service"),
//                                 value: item.type ?? "Canula",
//                               ),
//                             ),
//                             SizedBox(width: 16.w),
//                             Expanded(
//                               child: _buildInfoColumn(
//                                 label: translate("booking.price"),
//                                 value:
//                                     "${item.totalPrice?.toStringAsFixed(0) ?? '300'} EGP",
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Allergies Section
//             if (item.patientAllergies != null &&
//                 item.patientAllergies!.isNotEmpty) ...[
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                       text: translate("booking.allergies"),
//                       fontSize: AppStyle.average.sp,
//                       fontWeight: FontWeight.w600,
//                       color: DMUtil.getPC(),
//                     ),
//                     SizedBox(height: 12.h),
//                     _buildAllergiesGrid(item.patientAllergies!),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.h),
//             ],

//             // Action Buttons
//             if (showActions) ...[
//               Padding(
//                 padding: EdgeInsets.all(16.w),
//                 child: RequestActions(item: item),
//               ),
//             ] else ...[
//               // Call, Chat, Find Request Buttons
//               Padding(
//                 padding: EdgeInsets.all(16.w),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: _buildActionButton(
//                         label: translate("booking.call"),
//                         onTap: () {
//                           // TODO: Call action
//                         },
//                       ),
//                     ),
//                     SizedBox(width: 12.w),
//                     Expanded(
//                       child: _buildActionButton(
//                         label: translate("booking.chat"),
//                         onTap: () {
//                           // TODO: Chat action
//                         },
//                       ),
//                     ),
//                     SizedBox(width: 12.w),
//                     Expanded(
//                       child: _buildActionButton(
//                         label: translate("booking.find_request"),
//                         onTap: () {
//                           // TODO: Find request action
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow({
//     required String label1,
//     required String value1,
//     required String label2,
//     required String value2,
//   }) {
//     return Row(
//       children: [
//         if (label1.isNotEmpty)
//           Expanded(
//             child: _buildInfoColumn(label: label1, value: value1),
//           ),
//         if (label2.isNotEmpty) ...[
//           SizedBox(width: 16.w),
//           Expanded(
//             child: _buildInfoColumn(label: label2, value: value2),
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildInfoColumn({
//     required String label,
//     required String value,
//     bool isFullWidth = false,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomText(
//           text: label,
//           color: DMUtil.getD2C().withOpacity(0.5),
//           fontSize: AppStyle.verySmall.sp,
//           fontWeight: FontWeight.w400,
//         ),
//         SizedBox(height: 4.h),
//         CustomText(
//           text: value,
//           color: DMUtil.getDC(),
//           fontSize: AppStyle.small.sp + 1,
//           fontWeight: FontWeight.w600,
//           maxLine: isFullWidth ? 3 : 2,
//         ),
//       ],
//     );
//   }

//   Widget _buildAllergiesGrid(List<String> allergies) {
//     return Wrap(
//       spacing: 12.w,
//       runSpacing: 12.h,
//       children: allergies.map((allergy) {
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.circle_outlined,
//               size: 12.w,
//               color: DMUtil.getD2C().withOpacity(0.6),
//             ),
//             SizedBox(width: 6.w),
//             CustomText(
//               text: allergy,
//               fontSize: AppStyle.small.sp,
//               color: DMUtil.getD2C(),
//             ),
//           ],
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildActionButton({
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 12.h),
//         decoration: BoxDecoration(
//           border: Border.all(color: DMUtil.getPC()),
//           borderRadius: BorderRadius.circular(20.r),
//         ),
//         child: Center(
//           child: CustomText(
//             text: label,
//             fontSize: AppStyle.small.sp,
//             fontWeight: FontWeight.w600,
//             color: DMUtil.getPC(),
//           ),
//         ),
//       ),
//     );
//   }
// }
