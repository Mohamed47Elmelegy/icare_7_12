import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter_translate/flutter_translate.dart';

class DoctorServicePriceRow extends StatelessWidget {
  final int serviceID;
  final String serviceName;
  final String price;
  const DoctorServicePriceRow({super.key, required this.serviceID, required this.price, required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => BookingBloc.get(context).add(UpdateBookingServiceListEvent(service: ServicesModel(id: serviceID, value: price, name: serviceName))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: serviceName,
            fontSize: AppStyle.small.sp,
            fontWeight: FontWeight.w600,
            color: DMUtil.getDC(),
          ),
          CustomText(
            text: "$price ${translate("icare.le")}",
            fontSize: AppStyle.small.sp,
            fontWeight: FontWeight.w600,
            color: DMUtil.getD2C(),
          ),
          BlocBuilder<BookingBloc, BookingState>(
            builder: (ctx, state) {
              var bloc = BookingBloc.get(ctx);
              int serviceIndex = bloc.orderServiceList.indexWhere((element) => element.id == serviceID);
              bool selected = serviceIndex != -1;
              return CircleAvatar(
                radius: 14.w,
                backgroundColor: selected ? DMUtil.getPC() : DMUtil.getWC(),
                child: Icon(
                  Icons.check,
                  size: 17.w,
                  color: selected ? DMUtil.getWC() : DMUtil.getPC(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
