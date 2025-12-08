import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/setting/presentation/screens/contact_us_screen.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ContactUsWidget extends StatelessWidget {
  const ContactUsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w),
      child: Column(
        children: [
          SmallWidget(title: translate("drawer.whats"), img: AppImages.whats,onTap: ()=> Util.sendWhatsApp("+966920003240"),),

          SmallWidget(title: translate("drawer.support"), img: AppImages.support,onTap: ()=> Util.call("8002446660") ,),

          SmallWidget(title: translate("drawer.contact"), img: AppImages.mail,onTap: ()=> Util.pushPage(const ContactScreen(), context),),

        ],
      ),
    );
  }
}


class SmallWidget extends StatelessWidget {
  final String img;
  final String title;
  final VoidCallback onTap;
  const SmallWidget({super.key,required this.title,required this.img,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(width: 1,color: DMUtil.getBCC())
        ),
        child: Row(
          children: [
            SvgPicture.asset(img,height: 24.w,),
            const SizedBox(width: 12,),
            CustomText(
              text: title,
              fontWeight: FontWeight.w600,
              fontSize: AppStyle.small.sp,
            ),
          ],
        ),
      ),
    );
  }
}
