import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/booking/data/models/order_model.dart';
import 'package:icare/core/strings/enum/order_enum.dart';

class BookingHistoryTapScreen extends StatefulWidget {
  const BookingHistoryTapScreen({super.key});

  @override
  State<BookingHistoryTapScreen> createState() =>
      _BookingHistoryTapScreenState();
}

class _BookingHistoryTapScreenState extends State<BookingHistoryTapScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch bookings for the patient being viewed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accountBloc = AccountBloc.get(context);
      final patientId = accountBloc.currentUser?.userId?.toString();
      if (patientId != null) {
        debugPrint(
            "📡 [BookingHistory] Fetching bookings for patient: $patientId");
        context.read<BookingBloc>().add(FetchAllOrderEvent(userId: patientId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is OrderLoadingState) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: CircularProgressIndicator(color: DMUtil.getPC()),
            ),
          );
        }

        final allBookings = context.read<BookingBloc>().bookingList;
        final patientId = AccountBloc.get(context).currentUser?.userId;

        // Filter bookings by patient ID and exclude pending ones if needed,
        // but usually history should show COMPLETED/CANCELLED.
        final patientBookings =
            allBookings.where((b) => b.userId == patientId).toList();

        // Sort by ID descending (newest first)
        patientBookings
            .sort((a, b) => (b.orderId ?? 0).compareTo(a.orderId ?? 0));

        if (patientBookings.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 60.h),
              child: Column(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 48.sp, color: DMUtil.getD2C()),
                  SizedBox(height: 16.h),
                  CustomText(
                    text: translate("order.no_orders"),
                    fontSize: AppStyle.small.sp,
                    color: DMUtil.getD2C(),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: patientBookings.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final booking = patientBookings[index];
            return _buildBookingCard(booking);
          },
        );
      },
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final status = OrderModel.getStatusViewCheck(booking.status.toString());
    Color statusColor;
    String statusText;

    switch (status) {
      case ORDER_STATUS.COMPLETED:
        statusColor = Colors.green;
        statusText = translate("order.completed");
        break;
      case ORDER_STATUS.ONGOING:
        statusColor = Colors.blue;
        statusText = translate("order.ongoing");
        break;
      case ORDER_STATUS.PENDING:
        statusColor = Colors.orange;
        statusText = translate("order.pending");
        break;
      case ORDER_STATUS.CANCELLED:
        statusColor = Colors.red;
        statusText = translate("order.canceled");
        break;
      default:
        statusColor = DMUtil.getD2C();
        statusText = booking.status.toString();
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: DMUtil.getWC(),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: DMUtil.getD2C().withValues(alpha: 0.2)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "#${booking.orderId}",
                fontSize: AppStyle.small.sp,
                fontWeight: FontWeight.bold,
                color: DMUtil.getPC(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: CustomText(
                  text: statusText,
                  fontSize: AppStyle.verySmall.sp - 2,
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.calendar_month, size: 16.sp, color: DMUtil.getD2C()),
              SizedBox(width: 8.w),
              CustomText(
                text: "${translate("order.date")}: ${booking.date ?? "-"}",
                fontSize: AppStyle.verySmall.sp,
                color: DMUtil.getDC(),
              ),
            ],
          ),
          if (booking.nurseName != null) ...[
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(Icons.person_outline, size: 16.sp, color: DMUtil.getD2C()),
                SizedBox(width: 8.w),
                CustomText(
                  text: "${translate("order.nurse")}: ${booking.nurseName}",
                  fontSize: AppStyle.verySmall.sp,
                  color: DMUtil.getDC(),
                ),
              ],
            ),
          ],
          if (booking.desc != null && booking.desc!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Divider(color: DMUtil.getD2C().withValues(alpha: 0.1)),
            SizedBox(height: 8.h),
            CustomText(
              text: booking.desc!,
              fontSize: AppStyle.verySmall.sp,
              color: DMUtil.getD2C(),
              maxLine: 3,
            ),
          ],
        ],
      ),
    );
  }
}
