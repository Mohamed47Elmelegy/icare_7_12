import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/home/presentation/widgets/activities/activities_list.dart';
import 'package:icare/features/home/presentation/widgets/activities/no_activities.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class UserActivities extends StatelessWidget {
  const UserActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: AppStyle.paddingFromV.h,
          horizontal: AppStyle.paddingFromH.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: translate("icare.what_you_doing_today"),
            fontSize: AppStyle.average.sp,
          ),
          const SizedBox(
            height: 10,
          ),
          if (Util.isCustomer()) const NoActivitiesWidget(),
          const SizedBox(
            height: 10,
          ),
          const ActivitiesList(),
        ],
      ),
    );
  }
}
