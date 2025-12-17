import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/enum/order_enum.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/shared_widgets/simple_taps.dart';

class BookingTapsRow extends StatelessWidget {
  const BookingTapsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (ctx, state) {
        var bloc = BookingBloc.get(ctx);
        return Container(
          height: 35.w,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: DMUtil.getBackGroundTaps()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TapWidget(
                title: translate("order.current_booking"),
                index: 0,
                selected: bloc.currentTapOrdersIndex == 0,
                width: 165,
                fn: () => bloc.add(const ChangeCurrentOrdersEvent(
                    type: ORDER_STATUS.ONGOING, index: 0)),
              ),
              TapWidget(
                title: translate("order.past_booking"),
                index: 1,
                selected: bloc.currentTapOrdersIndex == 1,
                width: 165,
                fn: () => bloc.add(const ChangeCurrentOrdersEvent(
                    type: ORDER_STATUS.COMPLETED, index: 1)),
              ),
            ],
          ),
        );
      },
    );
  }
}
