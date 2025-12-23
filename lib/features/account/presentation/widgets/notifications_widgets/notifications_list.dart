import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/widgets/notifications_widgets/notification_card.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/setting/domain/entities/notifications_entity.dart';
import 'package:icare/features/shared_widgets/empty_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, state) {
        var bloc = AccountBloc.get(ctx);
        if (state is FetchNotificationsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: kPrimary,
            ),
          );
        }

        return BlocBuilder<BookingBloc, BookingState>(
          builder: (context, bookingState) {
            var bookingBloc = BookingBloc.get(context);

            // Filter notifications locally to avoid empty spaces and duplicates
            // Only show notifications that:
            // 1. Are NOT 'order' type
            // 2. Are 'order' type AND the corresponding booking exists
            // 3. Remove duplicates based on orderID (keep the most recent)
            var visibleNotifications = <NotificationsEntity>[];
            var seenOrderIds = <String>{};

            for (var item in bloc.notificationList) {
              // Skip request-type notifications (offers)
              if (item.type == 'request') {
                continue;
              }

              if (item.type == 'order') {
                var booking =
                    bookingBloc.getBookingByOrderId(item.orderID.toString());

                // Skip if booking doesn't exist or if we've already seen this orderID
                if (booking == null ||
                    seenOrderIds.contains(item.orderID.toString())) {
                  continue;
                }

                seenOrderIds.add(item.orderID.toString());
                visibleNotifications.add(item);
              } else {
                visibleNotifications.add(item);
              }
            }

            if (visibleNotifications.isEmpty) {
              return const EmptyDataWidget();
            }

            return ListView.separated(
              itemCount: visibleNotifications.length,
              padding: EdgeInsets.symmetric(
                      horizontal: AppStyle.paddingFromH.w, vertical: 25.h) +
                  EdgeInsets.only(
                      bottom: visibleNotifications.length > 15 ? 40 : 200),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var item = visibleNotifications[index];
                return NotificationListCard(
                  item: item,
                );
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                height: 20.w,
              ),
            );
          },
        );
      },
    );
  }
}
