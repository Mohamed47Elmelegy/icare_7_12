import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../../../core/styles/app_style.dart';
import '../../../../../core/utils/dark_mode_utility.dart';
import '../../../../booking/domain/entities/order.dart';
import '../../../../shared_widgets/custom_text.dart';

class NotificationInfoSection extends StatelessWidget {
  final Booking? booking;

  const NotificationInfoSection({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    if (booking == null) return const SizedBox();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _InfoItem(
                label: translate("notification.patient"),
                value: booking!.userName ?? "N/A",
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _InfoItem(
                label: translate("notification.requested_service"),
                value: booking!.type ?? "N/A",
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _InfoItem(
                label: translate("notification.gender"),
                value: booking!.userGender == 'female'
                    ? translate("profile.female")
                    : translate("profile.male"),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _InfoItem(
                label: translate("notification.destination"),
                value: booking!.shippingAddress ?? "",
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: AppStyle.verySmall.sp,
          color: DMUtil.getD2C().withOpacity(.5),
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: value,
          fontSize: AppStyle.small.sp + 1,
          fontWeight: FontWeight.w600,
          isEllipsis: true,
        ),
      ],
    );
  }
}
