import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/booking/presentation/widgets/new_booking_widgets/available_nurses.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class SendNewBookingRequestBtn extends StatelessWidget {
  const SendNewBookingRequestBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (ctx, state) {
        if (state is SendNewBookingRequestLoadingState) {
          return const CircularProgressIndicator();
        }
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.w),
          child: CustomButton(
            height: 35.h,
            width: double.infinity,
            widget: CustomText(
              text: translate("order.send_request"),
              fontSize: AppStyle.average.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            color: DMUtil.getPC(),
            circular: 8,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                ),
                builder: (ctx) {
                  return const AvailableNurses();
                },
              );
            },
          ),
        );
      },
    );
  }
}
