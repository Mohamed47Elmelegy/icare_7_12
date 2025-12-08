import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        const SizedBox(height: 5,),
        CustomText(
          text: translate("order.no_orders"),
          color: kText1,
          fontWeight: FontWeight.w700,
          fontSize: AppStyle.small.sp,
        ),
        CustomText(
          text: translate("cart.why_wait"),
          color: kText1,
          fontWeight: FontWeight.w400,
          fontSize: AppStyle.small.sp,
        ),
      ],
    );
  }
}
