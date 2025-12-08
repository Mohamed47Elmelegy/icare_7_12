import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestDetails extends StatelessWidget {
  final String txt;
  const RequestDetails({super.key,required this.txt});

  static final TextEditingController caseDescTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.w,),
      // padding: EdgeInsets.symmetric(vertical: 12.w,horizontal: 5.w),
      decoration: BoxDecoration(
          color: DMUtil.getWC(),
          borderRadius: BorderRadius.circular(10)
      ),
      child: CustomText(text: txt, fontSize: AppStyle.average.sp,maxLine: 10,)
    );
  }
}
