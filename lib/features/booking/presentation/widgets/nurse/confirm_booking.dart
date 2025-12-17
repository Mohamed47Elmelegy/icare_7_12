import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ConfirmBookingRequestBtn extends StatelessWidget {
  final String orderID;
  const ConfirmBookingRequestBtn({super.key, required this.orderID});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (ctx, state) {
        return CustomButton(
          height: 35.h,
          width: 150.w,
          widget: CustomText(
            text: translate("button.confirm"),
            fontSize: AppStyle.average.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          color: DMUtil.getPC(),
          circular: 8,
          onPressed: () => BookingBloc.get(context).add(UpdateOrderEvent(
            data: {
              'booking_id': orderID,
              'status': 'ONGOING',
            },
          )),
        );
      },
    );
  }
}
