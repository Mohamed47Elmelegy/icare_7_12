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
import 'package:icare/features/nurse/presentation/bloc/nurse_state.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';

class RequestButton extends StatelessWidget {
  const RequestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NurseBloc, NurseState>(
      builder: (ctx, state) {
        var bloc = NurseBloc.get(ctx);
        if (bloc.currentNurse == null) return const SizedBox.shrink();
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
                    backgroundColor: DMUtil.getPC(),
                  ),
                );
              }
              bool userHasSelectedService =
                  bookingBloc.orderServiceList.isNotEmpty;
              return CustomButton(
                  height: 40.h,
                  width: 180.w,
                  widget: CustomText(
                    text: userHasSelectedService
                        ? translate("nurse.request")
                        : translate("icare.select_service_first"),
                    fontSize: AppStyle.average.sp,
                    color: userHasSelectedService
                        ? DMUtil.getWC()
                        : DMUtil.getPC(),
                  ),
                  color:
                      userHasSelectedService ? DMUtil.getPC() : DMUtil.getWC(),
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

                    final res = await Util.pushPage(
                        MapScreen(
                            isSet: true,
                            title:
                                translate('profile.confirm_current_location')),
                        context);
                    if (res != null && res is LocationMapEntity) {
                      bookingBloc.add(AddOrderEvent(
                          context: context,
                          payment: const PaymentOption(
                              paymentEnum: PaymentEnum.CASH),
                          orderData: {
                            'nurse_id': bloc.currentNurse?.id,
                            'lat': res.lat.toString(),
                            'long': res.long.toString(),
                            'address': res.address.toString(),
                          }));
                    }
                  });
            },
          ),
        );
      },
    );
  }
}
