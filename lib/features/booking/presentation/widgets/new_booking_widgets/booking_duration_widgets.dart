import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ChooseWeeksDropDown extends StatelessWidget {
  const ChooseWeeksDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: translate("booking.weeks"),
          fontSize: AppStyle.small,
          color: DMUtil.getD2C(),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
            width: 84.w,
            decoration: BoxDecoration(
                color: DMUtil.getWC(), borderRadius: BorderRadius.circular(10)),
            child: BlocBuilder<BookingBloc, BookingState>(
              builder: (ctx, state) {
                var bloc = BookingBloc.get(ctx);
                return DropdownButton<String>(
                  value: null,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 10,
                  menuMaxHeight: 250.h,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: CustomText(
                      text: bloc.currentBooking != null &&
                              bloc.currentBooking!.week == null
                          ? bloc.currentBooking!.week.toString()
                          : translate("booking.not_selected"),
                      fontSize: AppStyle.verySmall.sp,
                      color: DMUtil.getD2C(),
                    ),
                  ),
                  isExpanded: true,
                  style: TextStyle(color: DMUtil.getD2C()),
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {},
                  items: <String>[
                    translate("booking.not_selected"),
                    "1 ${translate("booking.week")}",
                    "2 ${translate("booking.week")}",
                    "3 ${translate("booking.week")}",
                    "4 ${translate("booking.week")}",
                    "5 ${translate("booking.week")}",
                    "6 ${translate("booking.week")}",
                    "7 ${translate("booking.week")}",
                    "8 ${translate("booking.week")}",
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: CustomText(
                        text: value.toString(),
                        fontSize: AppStyle.small.sp,
                      ),
                    );
                  }).toList(),
                );
              },
            )),
      ],
    );
  }
}

class ChooseDaysDropDown extends StatelessWidget {
  const ChooseDaysDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: translate("booking.days"),
          fontSize: AppStyle.small,
          color: DMUtil.getD2C(),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
            width: 84.w,
            decoration: BoxDecoration(
                color: DMUtil.getWC(), borderRadius: BorderRadius.circular(10)),
            child: BlocBuilder<BookingBloc, BookingState>(
              builder: (ctx, state) {
                var bloc = BookingBloc.get(ctx);
                return DropdownButton<String>(
                  value: null,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 10,
                  menuMaxHeight: 250.h,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: CustomText(
                      text: bloc.currentBooking != null &&
                              bloc.currentBooking!.week == null
                          ? bloc.currentBooking!.week.toString()
                          : translate("booking.not_selected"),
                      fontSize: AppStyle.verySmall.sp,
                      color: DMUtil.getD2C(),
                    ),
                  ),
                  isExpanded: true,
                  style: TextStyle(color: DMUtil.getD2C()),
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {},
                  items: <String>[
                    translate("booking.not_selected"),
                    "1",
                    "2",
                    "3",
                    "4",
                    "5",
                    "6",
                    "7",
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: CustomText(
                        text: value.toString(),
                        fontSize: AppStyle.small.sp,
                      ),
                    );
                  }).toList(),
                );
              },
            )),
      ],
    );
  }
}

class ChooseHoursDropDown extends StatelessWidget {
  const ChooseHoursDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: translate("booking.hours"),
          fontSize: AppStyle.small,
          color: DMUtil.getD2C(),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
            width: 84.w,
            decoration: BoxDecoration(
                color: DMUtil.getWC(), borderRadius: BorderRadius.circular(10)),
            child: BlocBuilder<BookingBloc, BookingState>(
              builder: (ctx, state) {
                var bloc = BookingBloc.get(ctx);
                return DropdownButton<String>(
                  value: null,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 10,
                  menuMaxHeight: 250.h,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: CustomText(
                      text: bloc.currentBooking != null &&
                              bloc.currentBooking!.week == null
                          ? bloc.currentBooking!.week.toString()
                          : translate("booking.not_selected"),
                      fontSize: AppStyle.verySmall.sp,
                      color: DMUtil.getD2C(),
                    ),
                  ),
                  isExpanded: true,
                  style: TextStyle(color: DMUtil.getD2C()),
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {},
                  items: <String>[
                    translate("booking.not_selected"),
                    "1 ${translate("booking.hour")}",
                    "2 ${translate("booking.hour")}",
                    "3 ${translate("booking.hour")}",
                    "4 ${translate("booking.hour")}",
                    "5 ${translate("booking.hour")}",
                    "6 ${translate("booking.hour")}",
                    "7 ${translate("booking.hour")}",
                    "8 ${translate("booking.hour")}",
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: CustomText(
                        text: value.toString(),
                        fontSize: AppStyle.small.sp,
                      ),
                    );
                  }).toList(),
                );
              },
            )),
      ],
    );
  }
}
