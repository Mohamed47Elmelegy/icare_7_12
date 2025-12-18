// ignore_for_file: use_build_context_synchronously

import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class DateFilterWidget extends StatelessWidget {
  const DateFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? dateTime = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2022, 8),
          lastDate: DateTime(2024),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: kPrimary,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        BookingBloc.get(context).add(FilterOrderByDate(dateTime: dateTime));
      },
      child: Container(
        alignment: Alignment.center,
        width: 87.w,
        height: 23.h,
        // margin:  EdgeInsets.only(top: AppStyle.paddingFromTop.h-10),
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              text: translate("order.by_date"),
              color: Colors.black,
              fontSize: AppStyle.small.sp - 1,
              fontFamily: primaryFontBold,
              alignCenter: true,
            ),
            Row(
              children: [
                Container(
                  height: 20.h,
                  width: 1.3,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.arrow_downward,
                  color: Colors.black,
                  size: 17.w,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
