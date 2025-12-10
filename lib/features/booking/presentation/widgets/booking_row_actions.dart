// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/presentation/widgets/completed_booking_menu.dart';
import 'package:icare/features/booking/presentation/widgets/ongoing_booking_menu.dart';
import 'package:icare/features/booking/data/models/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/core/strings/enum/order_enum.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';

class BookingRowActions extends StatelessWidget {
  final Booking item;
  final NurseEntity orderNurse;
  const BookingRowActions({
    super.key,
    required this.item,
    required this.orderNurse,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, state) {
        var accountBloc = AccountBloc.get(ctx);
        var currentUser = accountBloc.currentUser;
        if (currentUser == null) return const SizedBox.shrink();

        // Check if order is completed
        if (OrderModel.getStatusViewCheck(item.status.toString()) ==
            ORDER_STATUS.COMPLETED) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CompletedBookingMenuWidget(
                item: item,
                orderNurse: orderNurse,
                currentUser: currentUser,
              ),
            ],
          );
        }

        // Show new button layout for ongoing orders (for patients only)
        if (Util.isCustomer()) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Call button
              Expanded(
                child: CustomButton(
                  height: 24.h,
                  width: double.infinity,
                  color: Colors.transparent,
                  sideColor: DMUtil.getPC(),
                  sideWidth: 1,
                  circular: 20,
                  widget: CustomText(
                    text: translate("order.call"),
                    fontSize: AppStyle.small.sp,
                    color: DMUtil.getPC(),
                    fontWeight: FontWeight.w500,
                  ),
                  onPressed: () => _handleCall(context),
                ),
              ),
              // Chat button
              SizedBox(width: 16.w),
              Expanded(
                child: CustomButton(
                  height: 24.h,
                  width: double.infinity,
                  color: Colors.transparent,
                  sideColor: DMUtil.getPC(),
                  sideWidth: 1,
                  circular: 20,
                  widget: CustomText(
                    text: translate("profile.chat"),
                    fontSize: AppStyle.small.sp,
                    color: DMUtil.getPC(),
                    fontWeight: FontWeight.w500,
                  ),
                  onPressed: () => _handleChat(context),
                ),
              ),
            ],
          );
        }

        // For nurses, show the old menu
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OnGoingBookingMenuWidget(item: item, orderNurse: orderNurse),
          ],
        );
      },
    );
  }

  void _handleChat(BuildContext context) {
    Util.openChat(
      context: context,
      receiverID: item.nurseID.toString(),
      receiverName: item.nurseName.toString(),
      chatRoomID: item.orderId.toString(),
    );
  }

  Future<void> _handleCall(BuildContext context) async {
    await Util.makeCall(
      context: context,
      phoneNumber: orderNurse.userData?.phoneNumber,
    );
  }
}
