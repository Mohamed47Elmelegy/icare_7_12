import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/today_monitoring_vitals.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';

class SavePatientVitalsAndCompleteBookingBtn extends StatefulWidget {
  final Booking booking;
  final GlobalKey<TodayMonitoringVitalsState> vitalsKey;
  final VoidCallback? onCompleted;

  const SavePatientVitalsAndCompleteBookingBtn({
    super.key,
    required this.booking,
    required this.vitalsKey,
    this.onCompleted,
  });

  @override
  State<SavePatientVitalsAndCompleteBookingBtn> createState() =>
      _SavePatientVitalsAndCompleteBookingBtnState();
}

class _SavePatientVitalsAndCompleteBookingBtnState
    extends State<SavePatientVitalsAndCompleteBookingBtn> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingBloc, BookingState>(
      listener: (context, state) {
        if (_isProcessing) {
          if (state is UpdateOrderSuccessfullyState) {
            // Success - show message and call completion callback
            SnackBarBuilder.showFeedBackMessage(
              context,
              translate("order.order_completed_successfully"),
              DMUtil.getGreen(),
            );
            setState(() {
              _isProcessing = false;
            });
            if (widget.onCompleted != null) {
              widget.onCompleted!();
            }
          } else if (state is OrderErrorState) {
            // Error - show error message
            SnackBarBuilder.showFeedBackMessage(
              context,
              state.errors,
              DMUtil.getRED(),
            );
            setState(() {
              _isProcessing = false;
            });
          }
        }
      },
      builder: (ctx, state) {
        return Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(10),
          child: CustomButton(
            height: 34.w,
            width: 250.w,
            widget: _isProcessing
                ? SizedBox(
                    height: 20.w,
                    width: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(DMUtil.getWC()),
                    ),
                  )
                : CustomText(
                    text: "Save & Complete",
                    fontSize: AppStyle.small.sp,
                    fontWeight: FontWeight.w600,
                    color: DMUtil.getWC(),
                  ),
            color: DMUtil.getPC(),
            onPressed: _isProcessing
                ? null
                : () async {
                    // Get vital values from the widget
                    final vitalsState = widget.vitalsKey.currentState;
                    if (vitalsState != null) {
                      final vitalValues = vitalsState.getVitalValues();

                      // Set processing flag
                      setState(() {
                        _isProcessing = true;
                      });

                      // Update order status to COMPLETED with vital signs data
                      BookingBloc.get(context).add(UpdateOrderEvent(
                        data: {
                          'booking_id': widget.booking.orderId.toString(),
                          'status': 'COMPLETED',
                          'heart_rate': vitalValues['heart_rate'],
                          'blood_pressure': vitalValues['blood_pressure'],
                          'height': vitalValues['height'],
                          'weight': vitalValues['weight'],
                          'pulse_rate': vitalValues['pulse_rate'],
                        },
                      ));
                    }
                  },
          ),
        );
      },
    );
  }
}
