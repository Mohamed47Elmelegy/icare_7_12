import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/booking/presentation/widgets/new_booking_widgets/booking_duration_widgets.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AccommodationDurationWidget extends StatelessWidget {
  const AccommodationDurationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 60.w,
            child: CustomText(
              text: translate("booking.accommodation_duration"),
              fontSize: AppStyle.verySmall.sp+1,
              fontWeight: FontWeight.w600,
              maxLine: 2,
            ),
          ),
          const ChooseWeeksDropDown(),
          const ChooseDaysDropDown(),
          const ChooseHoursDropDown(),
        ],
      ),
    );
  }
}
