import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/data/models/order_model.dart';
import 'package:icare/core/strings/enum/order_enum.dart';
import 'package:icare/features/booking/presentation/widgets/booking_description.dart';
import 'package:icare/features/booking/presentation/widgets/booking_info_column.dart';
import 'package:icare/features/booking/presentation/widgets/booking_info_row.dart';
import 'package:icare/features/booking/presentation/widgets/booking_row_actions.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/account/data/data_sources/account_data_source.dart';
import 'package:icare/features/locations/presentation/screens/set_and_get_coordinates.dart';
import 'package:icare/core/utils/small_fun.dart';

/// Patient view for booking details - shows nurse information
class BookingPatientView extends StatelessWidget {
  final Booking item;

  const BookingPatientView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // ⚠️ مؤقت – سيتم حذفه بعد decouple
    final list = NurseBloc.get(context).nursesList;
    final index = list.indexWhere((e) => item.nurseID == e.id);
    final orderNurse = index != -1 ? list[index] : null;

    if (orderNurse == null) {
      return Center(
        child: CustomText(
          text: translate("toast.oops"),
          fontSize: AppStyle.average.sp,
          color: DMUtil.getD2C(),
        ),
      );
    }

    return Column(
      children: [
        _NurseInfoCard(item: item, orderNurse: orderNurse),
        if (item.desc?.isNotEmpty == true) BookingDescription(desc: item.desc!),
        Padding(
          padding: EdgeInsets.all(16.w),
          child: BookingRowActions(
            item: item,
            orderNurse: orderNurse,
          ),
        ),
      ],
    );
  }
}

/// Private widget for nurse information card
class _NurseInfoCard extends StatelessWidget {
  final Booking item;
  final dynamic orderNurse;

  const _NurseInfoCard({
    required this.item,
    required this.orderNurse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: DMUtil.getWC(),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with image and name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: DMUtil.getPC().withValues(alpha: 0.1),
                  image: orderNurse.userData?.image != null &&
                          orderNurse.userData!.image!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(orderNurse.userData!.image!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: orderNurse.userData?.image == null ||
                        orderNurse.userData!.image!.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 30.w,
                        color: DMUtil.getPC(),
                      )
                    : null,
              ),
              SizedBox(width: 12.w),
              // Name and rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: item.nurseName ?? "",
                      fontSize: AppStyle.average.sp,
                      fontWeight: FontWeight.w600,
                      color: DMUtil.getDC(),
                      maxLine: 2,
                    ),
                    SizedBox(height: 4.h),
                    if (orderNurse.reviewList != null &&
                        orderNurse.reviewList!.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16.w,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 4.w),
                          CustomText(
                            text:
                                _calculateAverageRating(orderNurse.reviewList!)
                                    .toStringAsFixed(1),
                            fontSize: AppStyle.small.sp,
                            color: DMUtil.getD2C(),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Info rows
          BookingInfoRow(
            label1: translate("order.requested_service"),
            value1: item.type ?? orderNurse.viewTypeText(),
            label2: translate("order.gender"),
            value2: (orderNurse.userData?.isWomen == true
                ? translate("profile.female")
                : translate("profile.male")),
          ),
          SizedBox(height: 12.h),

          // Distance row (if available)
          if (orderNurse.distanceKM != null && orderNurse.distanceKM! > 0)
            Column(
              children: [
                BookingInfoColumn(
                  label: translate("icare.distance"),
                  value: "${orderNurse.distanceKM!.toStringAsFixed(1)} Km",
                  isFullWidth: true,
                ),
                SizedBox(height: 12.h),
              ],
            ),

          // On Map button - only show for non-completed bookings
          if (item.status != null &&
              OrderModel.getStatusViewCheck(item.status!) !=
                  ORDER_STATUS.COMPLETED)
            InkWell(
              onTap: () async {
                try {
                  final trackingNurse =
                      await UserServiceRemoteDataSource.getUserFullData(
                    orderNurse.userData!.userId.toString(),
                  );
                  Util.pushPage(
                    MapScreen(
                      isSet: true,
                      title: trackingNurse.userName.toString(),
                      latitude: trackingNurse.lat.toString(),
                      longitude: trackingNurse.long.toString(),
                      userID: trackingNurse.userId.toString(),
                      userImg: trackingNurse.image,
                    ),
                    context,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(translate("toast.oops"))),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: DMUtil.getD2C().withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16.w,
                      color: DMUtil.getPC(),
                    ),
                    SizedBox(width: 6.w),
                    CustomText(
                      text: translate("order.on_map"),
                      fontSize: AppStyle.small.sp,
                      color: DMUtil.getPC(),
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Helper function to calculate average rating from review list
double _calculateAverageRating(List<dynamic> reviewList) {
  if (reviewList.isEmpty) return 0.0;

  double total = 0;
  int count = 0;

  for (var review in reviewList) {
    if (review.ratingValue != null) {
      total += review.ratingValue!;
      count++;
    }
  }

  return count > 0 ? total / count : 0.0;
}
