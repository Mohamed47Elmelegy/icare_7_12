import 'package:icare/core/strings/enum/user_enum.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NurseSpecialityDropDown extends StatelessWidget {
  const NurseSpecialityDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.w),
      decoration: BoxDecoration(
          color: DMUtil.getWC(), borderRadius: BorderRadius.circular(10)),
      child: DropdownButton<String>(
        value: null,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 10,
        menuMaxHeight: 250.h,
        hint: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CustomText(
            text: UserEnum.CUSTOMER.name,
            fontSize: AppStyle.small.sp,
            color: DMUtil.getD2C(),
          ),
        ),
        isExpanded: true,
        style: TextStyle(color: DMUtil.getD2C()),
        underline: const SizedBox(),
        onChanged: (String? newValue) {},
        items: <String>[
          "Rapid visit",
          "Accommodation",
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: CustomText(
              text: value.toString(),
              fontSize: AppStyle.small.sp,
            ),
          );
        }).toList(),
      ),
    );
  }
}
