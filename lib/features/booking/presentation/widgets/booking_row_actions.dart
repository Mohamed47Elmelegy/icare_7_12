// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/presentation/widgets/completed_booking_menu.dart';
import 'package:icare/features/booking/presentation/widgets/ongoing_booking_menu.dart';
import 'package:icare/features/booking/data/models/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/core/strings/enum/order_enum.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';


class BookingRowActions extends StatelessWidget {
  final Booking item;
  final NurseEntity orderNurse;
  const BookingRowActions({super.key,required this.item,required this.orderNurse});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc,AccountState>(
      builder: (ctx,state){
        var accountBloc = AccountBloc.get(ctx);
        var currentUser = accountBloc.currentUser;
        if(currentUser==null)return const SizedBox.shrink();
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if(OrderModel.getStatusViewCheck(item.status.toString())==ORDER_STATUS.COMPLETED)...[
              CompletedBookingMenuWidget(item: item, orderNurse: orderNurse, currentUser: currentUser),
            ]else ...[
              OnGoingBookingMenuWidget(item: item, orderNurse: orderNurse),
            ],
          ],
        );
      },
    );
  }
}
