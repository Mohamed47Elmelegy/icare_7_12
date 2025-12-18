import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchWidget extends StatelessWidget {
  final bool showDrawer;
  const SearchWidget({super.key, this.showDrawer = true});
  static TextEditingController searchTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (showDrawer)
          InkWell(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: SvgPicture.asset(
              AppImages.drawer,
              colorFilter: ColorFilter.mode(DMUtil.getD2C(), BlendMode.srcIn),
              width: (10.h + 12.w),
            ),
          ),

        const SizedBox(
          width: 10,
        ),

        // Expanded(
        //   child: Container(
        //       height: 42.h,
        //       decoration: const BoxDecoration(
        //           borderRadius: BorderRadius.all(Radius.circular(10))
        //       ),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           SizedBox(
        //             height: 42.h,
        //             width: 240.w,
        //             child: CustomTextFromField(
        //               onChanged: (val){
        //                 if(val.toString().trim()==""){
        //                 }
        //               },
        //
        //               hintText: translate("app_bar.search"),
        //               labelText: "",
        //               radius: 10,
        //               textEditingController: searchTextEditingController,
        //               cursorColor: kPrimary,
        //               validator: () {},
        //               prefixIcon: InkWell(
        //
        //                 child: Icon(
        //                   CupertinoIcons.search,
        //                   color: DMUtil.getDC(),
        //                 ),
        //               ),
        //               smallPadding: true,
        //               obscureText: false,
        //               hasBorder: true,
        //               isLabelError: false,
        //             ),
        //           ),
        //           SizedBox(width: 9.w,),
        //           const FilterRow(),
        //         ],
        //       )
        //   ),
        // ),
      ],
    );
  }
}
