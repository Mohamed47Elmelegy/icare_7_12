import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/widgets/profile_image_with_action.dart';
import 'package:icare/features/home/presentation/widgets/request_company/request_btn.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:icare/features/shared_widgets/logo_widget.dart';

import '../../../shared_widgets/switch_profile_status.dart';

class HomeBackGroundWithRadius extends StatelessWidget {
  final String? title;
  final bool? enableBackIcon;
  final bool setRequestBtn;
  const HomeBackGroundWithRadius(
      {super.key,
      this.title,
      this.enableBackIcon = false,
      this.setRequestBtn = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 195.w,
      padding: EdgeInsets.symmetric(
            horizontal: AppStyle.paddingFromH.w,
          ) +
          EdgeInsets.only(top: AppStyle.paddingFromTop.w),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          color: DMUtil.getPC()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (enableBackIcon == true)
                const BackArrowButton()
              else
                const SizedBox(width: 35),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LogoWidget(
                    width: 100,
                    height: 53,
                    isWhite: true,
                  ),
                  if (setRequestBtn && Util.isCustomer()) const RequestBtn(),
                ],
              ),
              Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                      color: DMUtil.getBC(),
                      borderRadius: BorderRadius.circular(50)),
                  child: const Center(child: NotificationIcon())),
            ],
          ),
          SizedBox(
            height: 12.w,
          ),
          BlocBuilder<AccountBloc, AccountState>(
            builder: (ctx, state) {
              var bloc = AccountBloc.get(ctx);
              var currentUser = bloc.currentUser;
              if (currentUser == null) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title ?? Util.getGreeting(),
                    color: DMUtil.getWC(),
                    fontWeight: FontWeight.w400,
                    fontSize: AppStyle.average.sp,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: currentUser.userName ?? "",
                          color: DMUtil.getWC(),
                          fontWeight: FontWeight.w600,
                          fontSize: AppStyle.large.sp,
                        ),
                        if (Util.isNurse()) ...[
                          SizedBox(
                            width: 10.w,
                          ),
                          const SwitchProfileStatus(),
                        ],
                      ]),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
