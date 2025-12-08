import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterRow extends StatelessWidget {
  const FilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: (){
            showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: Colors.transparent,
              shape:  const RoundedRectangleBorder(
                borderRadius:  BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
              ),
              builder: (ctx){
                return const SizedBox();
              },
            );
          },
          // child: SvgPicture.asset(AppImages.sort,colorFilter: ColorFilter.mode(DMUtil.getD2C(), BlendMode.srcIn),width: (10.h + 12.w),),
        ),
        SizedBox(width: 4.w,),
        InkWell(
          onTap: (){
            showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
              ),
              builder: (ctx){
                return const SizedBox();
              },
            );
          },
          // child: SvgPicture.asset(AppImages.filter,colorFilter: ColorFilter.mode(DMUtil.getD2C(), BlendMode.srcIn),width: (10.h + 16.w),),
        ),


      ],
    );
  }
}
