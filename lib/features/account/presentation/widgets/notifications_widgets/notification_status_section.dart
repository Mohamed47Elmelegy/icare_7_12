import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/home/presentation/widgets/request_company/request_details_screen.dart';
import 'package:icare/features/setting/domain/entities/notifications_entity.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'notification_action_buttons.dart';

class NotificationStatusSection extends StatelessWidget {
  final Booking? booking;
  final NotificationsEntity notification;

  const NotificationStatusSection({
    super.key,
    required this.booking,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    // Request type - show view offers button
    if (notification.type == 'request') {
      return CustomButton(
        height: 40.h,
        width: double.infinity,
        color: kPrimary,
        circular: 20,
        onPressed: () => Util.pushPage(
          RequestDetailsScreen(
            id: notification.id.toString(),
            requestEntity: notification.requestEntity,
          ),
          context,
        ),
        widget: CustomText(
          text: translate("home.view_all_offer"),
          fontSize: AppStyle.average.sp - 2,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    }

    // No booking found
    if (booking == null) return const SizedBox();

    // PENDING status - show accept/refuse buttons for nurses only
    if (booking!.status?.toUpperCase() == 'PENDING') {
      if (!Util.isCustomer()) {
        // Nurse/Doctor - show accept/refuse buttons
        return NotificationActionButtons(booking: booking!);
      } else {
        // Patient - show pending status
        return _buildPendingStatus();
      }
    }

    return const SizedBox();
  }

  Widget _buildPendingStatus() {
    return Container(
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
    );
  }
}