import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/booking/presentation/widgets/order_tracking_widgets/order_card_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';



class OrderList extends StatelessWidget {
  const OrderList({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc,BookingState>(
      builder: (ctx,state){
        var bloc = BookingBloc.get(ctx);
        var list = bloc.getCurrentOrdersByType();
        // if(state is OrderLoadingState) return const Center(child: CircularProgressIndicator(),);
        return ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: AppStyle.paddingFromV.w+10, horizontal: AppStyle.paddingFromH.w) + const EdgeInsets.only(bottom: 400),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var item = list[index];
            print(list.last.orderId);
            return OrderCardDetails(enableTracking: true,item: item,);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemCount: list.length,
        );
      },
    );
  }


}
