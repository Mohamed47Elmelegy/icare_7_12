import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/styles/app_style.dart';
import '../../../../booking/domain/entities/order.dart';
import '../../../../shared_widgets/custom_text.dart';

class NotificationStatusWidget extends StatelessWidget {
  final Booking booking;

  const NotificationStatusWidget({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final color = booking.status == 'Cancelled'
        ? Colors.red
        : booking.status == 'PENDING'
            ? Colors.orange
            : Colors.green;

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: CustomText(
          text: booking.statusView ?? booking.status ?? "",
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: AppStyle.average.sp,
        ),
      ),
    );
  }
}
