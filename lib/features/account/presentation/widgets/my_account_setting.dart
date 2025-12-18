import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/screens/account_data.dart';
import 'package:icare/features/locations/presentation/screens/my_locations.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/booking/presentation/screens/order_screen.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/root_app/bloc/root_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/setting/presentation/widgets/small_widgets.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class MyAccountSetting extends StatelessWidget {
  const MyAccountSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8.w,
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w - 4),
          child: CustomText(
            text: translate("profile.my_account"),
            color: DMUtil.getD2C().withOpacity(0.6),
            fontWeight: FontWeight.w600,
            fontSize: AppStyle.average.sp,
          ),
        ),
        Container(
          color: DMUtil.getWC(),
          margin: EdgeInsets.symmetric(vertical: 8.w),
          padding:
              EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w - 4),
          child: Column(
            children: [
              SettingLineOption(
                title: translate("profile.orders"),
                onTap: () => Util.pushPage(const OrderScreen(), context),
                widget: Row(
                  children: [
                    BlocBuilder<BookingBloc, BookingState>(
                      builder: (ctx, state) {
                        var bloc = BookingBloc.get(ctx);
                        var length = bloc.bookingList.length;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (length != 0)
                              CircleAvatar(
                                backgroundColor: DMUtil.getPC(),
                                radius: 11.w,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: CustomText(
                                    text: "$length",
                                    fontSize: AppStyle.small.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        );
                      },
                    ),
                    Icon(Icons.arrow_forward_ios,
                        color: DMUtil.getDC(), size: 15.w),
                  ],
                ),
              ),
              const Divider(),
              SettingLineOption(
                title: translate("profile.wishlist"),
                onTap: () => RootBloc.get(context)
                    .add(const ChangeIndex(index: 2, title: "")),
              ),
              const Divider(),
              SettingLineOption(
                title: translate("profile.addresses"),
                onTap: () => Util.pushPage(const MyLocationsScreen(), context),
              ),
              const Divider(),
              SettingLineOption(
                title: translate("profile.profile"),
                onTap: () => Util.pushPage(const AccountDataScreen(), context),
              ),
            ],
          ),
        )
      ],
    );
  }
}
