import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/locations/domain/entities/location_entity.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class LocationTypeViewWidget extends StatelessWidget {
  final LocationEntity locationEntity;
  const LocationTypeViewWidget({super.key, required this.locationEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: DMUtil.getRED()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.home_outlined,
            color: DMUtil.getWC(),
            size: AppStyle.average.w + 1,
          ),
          const SizedBox(
            width: 5,
          ),
          Padding(
            padding: EdgeInsets.only(top: Util.getLang() == "ar" ? 3 : 0),
            child: CustomText(
              text: locationEntity.locationType == "home"
                  ? translate("map.home")
                  : translate("map.work"),
              fontWeight: FontWeight.w600,
              alignCenter: true,
              color: DMUtil.getWC(),
              fontSize: AppStyle.small.sp - 2,
            ),
          ),
        ],
      ),
    );
  }
}
