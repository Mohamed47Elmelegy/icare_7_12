import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/screens/admin_screens/nurses/nurse_booking_available_card.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/shared_widgets/empty_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvailableNurses extends StatelessWidget {
  const AvailableNurses({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, bookingState) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (ctx, state) {
            var bloc = AccountBloc.get(ctx);
            var bookingBloc = BookingBloc.get(ctx);

            if (state is FetchNotificationsLoadingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: DMUtil.getPC2(),
                ),
              );
            }
            if (state is! FetchNotificationsLoadingState &&
                bloc.notificationList.isEmpty) {
              return const EmptyDataWidget();
            }

            // Get list of provider IDs that have ongoing bookings
            final ongoingBookedProviderIds =
                bookingBloc.getOngoingBookedProviderIds();

            debugPrint("📋 ========== AVAILABLE NURSES DEBUG ==========");
            debugPrint(
                "📊 Total users from AccountBloc: ${bloc.allUsers.length}");
            debugPrint(
                "🔄 Ongoing booked provider IDs: $ongoingBookedProviderIds");
            debugPrint(
                "📝 Ongoing bookings list length: ${bookingBloc.ongoingBookingsList.length}");

            // Filter out nurses/doctors that have ongoing bookings with current user
            final availableUsers = bloc.allUsers.where((user) {
              final isBooked = ongoingBookedProviderIds.contains(user.userId);
              debugPrint(
                  "👤 User: ${user.userName} (ID: ${user.userId}) - Booked: $isBooked");
              return !isBooked;
            }).toList();

            debugPrint(
                "✅ Available users after filter: ${availableUsers.length}");
            debugPrint("📋 ==========================================");

            if (availableUsers.isEmpty) {
              return const EmptyDataWidget();
            }

            return Container(
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: ListView.separated(
                itemCount: availableUsers.length,
                padding: EdgeInsets.symmetric(
                    horizontal: AppStyle.paddingFromH.w - 20, vertical: 10.h),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var item = availableUsers[index];
                  return NurseBookingAvailableCard(
                    nurse: item,
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 20.w,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
