import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/home/presentation/widgets/request_company/request_form.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class RequestBtn extends StatelessWidget {
  const RequestBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.w),
      child: CustomButton(
        height: 28.w,
        width: 116.w,
        widget: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: CustomText(
            text: translate("home.request"), 
            fontSize: AppStyle.average.sp,
            color: kPrimary,
          ),
        ),
        sideColor: kPrimary,
        sideWidth: 1,
        color: kWhite, 
        onPressed: ()=> openCarBottomSheet(context),
      ),
    );
  }
}

void openCarBottomSheet(context,){
  showModalBottomSheet(
    context: context,  
    isScrollControlled: true,  
    builder: (context) {  
      return AnimatedBuilder(  
        animation: Tween(begin:0.0, end:1.0).animate(CurvedAnimation(  
        parent: ModalRoute.of(context)!.animation!,  
        curve: Curves.easeInOut,)),  
        builder: (context, child) {  
            return Transform.translate(  
              offset: Offset(0,100 * (1 - ModalRoute.of(context)!.animation!.value)),  
              child: Container(  
                height: 560.w,
                decoration: BoxDecoration(
                  color: DMUtil.getWC(),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)
                  )
                ),  
                child: const RequestForm(),
              ),  
            );  
          },  
      );  
    },  
  );
}