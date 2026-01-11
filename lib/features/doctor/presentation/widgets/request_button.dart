import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/enum/payment_enum.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/booking/presentation/screens/main_order_screen.dart';
import 'package:icare/features/locations/presentation/screens/set_and_get_coordinates.dart';
import 'package:icare/features/doctor/presentation/bloc/doctor_state.dart';
import 'package:icare/features/doctor/presentation/bloc/doctors_bloc.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';

class RequestButton extends StatelessWidget {
  const RequestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (ctx, state) {
        var bloc = DoctorBloc.get(ctx);
        if (bloc.currentDoctor == null) return const SizedBox.shrink();
        return BlocListener<BookingBloc, BookingState>(
          listenWhen: (ctx, state) =>
              state is AssignOrderSuccessfullyState || state is OrderErrorState,
          listener: (ctx, state) {
            if (state is AssignOrderSuccessfullyState) {
              Util.pushPage(const MainBookingScreen(), context);
            } else if (state is OrderErrorState) {
              SnackBarBuilder.showFeedBackMessage(
                  context, state.errors, DMUtil.getRED());
            }
          },
          child: BlocBuilder<BookingBloc, BookingState>(
            builder: (ctx, state) {
              var bookingBloc = BookingBloc.get(ctx);
              if (state is SendNewBookingRequestLoadingState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CircularProgressIndicator(
                      backgroundColor: DMUtil.getPC()),
                );
              }
              bool userHasSelectedService =
                  bookingBloc.orderServiceList.isNotEmpty;
              return CustomButton(
                height: 40.h,
                width: 180.w,
                widget: CustomText(
                  text: userHasSelectedService
                      ? translate("doctor.request")
                      : translate("icare.select_service_first"),
                  fontSize: AppStyle.average.sp,
                  color:
                      userHasSelectedService ? DMUtil.getWC() : DMUtil.getPC(),
                ),
                color: userHasSelectedService ? DMUtil.getPC() : DMUtil.getWC(),
                sideWidth: userHasSelectedService ? 0 : 1,
                sideColor: userHasSelectedService
                    ? Colors.transparent
                    : DMUtil.getD2C(),
                onPressed: () async {
                  if (!Util.checkUser()) {
                    return SnackBarBuilder.showFeedBackMessage(
                        context, translate("toast.login"), DMUtil.getRED());
                  }
                  if (!userHasSelectedService) {
                    return SnackBarBuilder.showFeedBackMessage(
                        context,
                        translate("icare.select_service_first"),
                        DMUtil.getPC());
                  }

                  if (bookingBloc
                      .hasActiveBookingWithProvider(bloc.currentDoctor!.id)) {
                    return SnackBarBuilder.showFeedBackMessage(
                        context,
                        translate("icare.ongoing_booking_exists_generic"),
                        DMUtil.getRED());
                  }

                  final res = await Util.pushPage(
                      MapScreen(
                          isSet: true,
                          title: translate('profile.confirm_current_location')),
                      context);
                  if (res != null && res is LocationMapEntity) {
                    bookingBloc.add(AddOrderEvent(
                        context: context,
                        payment:
                            const PaymentOption(paymentEnum: PaymentEnum.CASH),
                        orderData: {
                          'doctor_id': bloc.currentDoctor?.id,
                          'lat': res.lat.toString(),
                          'long': res.long.toString(),
                          'address': res.address.toString(),
                        }));
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
