import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class MovmentLevelSelectDropDown extends StatelessWidget {
  const MovmentLevelSelectDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: DMUtil.getWC(),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: DMUtil.getOpacity())),
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (ctx, state) {
          var bloc = BookingBloc.get(ctx);
          return DropdownButton<String>(
            value: null,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 10,
            menuMaxHeight: 250.h,
            hint: CustomText(
              text: bloc.movmentLevel,
              fontSize: AppStyle.small.sp,
            ),
            isExpanded: true,
            style: TextStyle(color: DMUtil.getD2C()),
            underline: const SizedBox(),
            onChanged: (String? newValue) => bloc.add(
                UpdateRequestFormDataEvent(
                    data: {'movment_level': newValue.toString()})),
            items: ['قادر علي الحركه', 'محدود الحركة', 'غير قادر علي الحركة']
                .map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value.toString(),
                child: CustomText(
                  text: value,
                  fontSize: AppStyle.small.sp,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
