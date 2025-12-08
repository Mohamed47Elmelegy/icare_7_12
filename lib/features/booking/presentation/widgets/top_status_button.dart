import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmallTapItem extends StatelessWidget {
  final String title;
  final bool enable;
  const SmallTapItem({super.key,required this.title,required this.enable});

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(20);
    return BlocBuilder<AccountBloc,AccountState>(
      builder: (ctx,state){
        // var user = AccountBloc.get(ctx).currentUser;
        // if(user==null)return const SizedBox.shrink();
        return Tab(
          iconMargin: EdgeInsets.zero,
          height: 35.h,
          child: Container(
            alignment: Alignment.center,
            height: 35.h,
            padding: EdgeInsets.symmetric(vertical: 3.w),
            margin: const EdgeInsets.symmetric(horizontal: 5,),
            decoration: BoxDecoration(
              color: enable?DMUtil.getRED():DMUtil.getWC(),
              borderRadius: borderRadius,
              border: Border.all(color: DMUtil.getRED())
            ),
            child: CustomText(
              text: title,
              color: enable?Colors.white:DMUtil.getDC(),
              fontSize: AppStyle.average.sp,
              fontFamily: primaryFontSemiBold,
              alignCenter: true,
            ),
          ),
        );
      },
    );

  }
}