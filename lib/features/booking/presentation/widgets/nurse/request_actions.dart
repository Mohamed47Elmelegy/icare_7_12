import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/services_bloc.dart';
import 'package:icare/features/account/presentation/bloc/services_event.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/booking/presentation/screens/order_screen.dart';
import 'package:icare/features/booking/presentation/widgets/nurse/confirm_booking.dart';
import 'package:icare/features/booking/presentation/widgets/nurse/refused_booking.dart';
import 'package:icare/features/root_app/screens/root_screen.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';

class RequestActions extends StatelessWidget {
  final Booking item;
  const RequestActions({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: BlocListener<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is UpdateOrderSuccessfullyState) {
              SnackBarBuilder.showFeedBackMessage(
                  context, translate('order.ongoing'), Colors.green);
              navigateToOrderScreen(context);
            } else if (state is RefuesdOrderSuccessfullyState) {
              SnackBarBuilder.showFeedBackMessage(
                  context, translate('order.canceled'), Colors.green);
              navigateToOrderScreen(context);
            } else if (state is OrderErrorState) {
              SnackBarBuilder.showFeedBackMessage(
                  context, state.errors.toString(), Colors.red);
            } else if (state is OrderInitialState) {
              // Ignore initial state
            } else {
              SnackBarBuilder.showFeedBackMessage(
                  context, translate('toast.oops'), Colors.red);
            }
          },
          listenWhen: (previous, current) =>
              current is UpdateOrderSuccessfullyState ||
              current is RefuesdOrderSuccessfullyState ||
              current is OrderErrorState,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ConfirmBookingRequestBtn(
                orderID: item.orderId.toString(),
              ),
              RefusedBookingRequestBtn(
                orderID: item.orderId.toString(),
              ),
            ],
          ),
        ));
  }

  navigateToOrderScreen(context) {
    BookingBloc.get(context).add(const FetchAllOrderEvent());
    ServicesBloc.get(context).add(const FetchAllNotificationsEvent());
    Util.pushPageAndRemoveRoutes(const RootScreen(), context);
    Util.pushPage(const OrderScreen(), context);
  }
}
