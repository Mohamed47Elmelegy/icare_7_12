import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class NotificationActionButtons extends StatelessWidget {
  final Booking booking;

  const NotificationActionButtons({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BookingBloc>();

    return Row(
      children: [
        Expanded(
          child: CustomButton(
            height: 40.h,
            color: Colors.green.shade50,
            circular: 20,
            onPressed: () {
              // Accept order
              bloc.acceptOrder(booking);
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(translate("notification.order_accepted")),
                  backgroundColor: Colors.green,
                ),
              );
            },
            widget: CustomText(
              text: translate("notification.accept"),
              color: Colors.green,
              fontSize: AppStyle.average.sp - 2,
              fontWeight: FontWeight.w600,
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
              // Refuse order
              bloc.refuseOrder(booking);
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(translate("notification.order_refused")),
                  backgroundColor: Colors.red,
                ),
              );
            },
            widget: CustomText(
              text: translate("notification.reject"),
              color: Colors.red,
              fontSize: AppStyle.average.sp - 2,
              fontWeight: FontWeight.w600,
            ),
            width: 51.w,
          ),
        ),
      ],
    );
  }
}