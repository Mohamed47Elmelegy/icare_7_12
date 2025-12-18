import 'package:icare/core/strings/enum/order_enum.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/locations/presentation/widgets/circle_dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class TrackingLineWidget extends StatelessWidget {
  final ORDER_STATUS status;
  const TrackingLineWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleDotsWidget(
                isEnabled: status == ORDER_STATUS.PENDING ? true : false,
                isOpacity: status != ORDER_STATUS.PENDING ? true : false),
            Container(
              width: 6.w,
              height: 85.h,
              color: DMUtil.getRED().withOpacity(0.6),
            ),
            CircleDotsWidget(
                isEnabled: status == ORDER_STATUS.ONGOING ? true : false,
                isOpacity: status != ORDER_STATUS.ONGOING ? true : false),
            ///////////////////////////////
            Container(
              width: 6.w,
              height: 85.h,
              color: DMUtil.getRED().withOpacity(0.6),
            ),
            CircleDotsWidget(
                isEnabled: status == ORDER_STATUS.COMPLETED ? true : false,
                isOpacity: status != ORDER_STATUS.COMPLETED ? true : false),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: translate("button.confirmed"),
              color: DMUtil.getD2C(),
              fontSize: AppStyle.average.sp,
            ),
            CustomText(
              text: translate("order.order_process"),
              color: DMUtil.getD2C(),
              fontSize: AppStyle.small.sp,
            ),
            SizedBox(
              height: 62.h,
            ),
            CustomText(
              text: translate("order.ongoing"),
              color: DMUtil.getD2C(),
              fontSize: AppStyle.average.sp,
            ),
            SizedBox(
              height: 70.h,
            ),
            CustomText(
              text: translate("order.delivered"),
              color: DMUtil.getD2C(),
              fontSize: AppStyle.average.sp,
            ),
          ],
        )
      ],
    );
  }
}
