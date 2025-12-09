import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/screens/edit_profile_screen.dart';
import 'package:icare/features/account/presentation/screens/notifications/notifications_screen.dart';
import 'package:icare/features/account/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/shared_widgets/logo_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icare/features/shared_widgets/switch_language.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? icon;
  final Widget? leadingIcon;
  final bool justLogo;
  final bool whiteLogo;
  final Color? textColor;
  final Color backGroundColor;
  const GlobalAppBar(
      {super.key,
      this.title,
      this.icon,
      this.leadingIcon,
      this.justLogo = false,
      this.whiteLogo = false,
      this.backGroundColor = Colors.transparent,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(double.infinity, AppStyle.appBarHeight.w),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              left: 10.w, right: 10.w, top: AppStyle.paddingFromTop.h),
          decoration: BoxDecoration(
            color: backGroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (justLogo) ...[
                Expanded(
                  child: Stack(
                    alignment: Util.getLang() == "ar"
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    children: [
                      leadingIcon ?? const SizedBox.shrink(),
                      if (justLogo)
                        const LogoWidget(
                          height: 140,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                    ],
                  ),
                ),
              ] else ...[
                leadingIcon ?? const SizedBox.shrink(),
                if (title != null)
                  Expanded(
                    child: Padding(
                      padding: leadingIcon != null
                          ? EdgeInsets.only(
                              left: Util.getLang() == "ar" ? 40.w : 0,
                              right: Util.getLang() != "ar" ? 40.w : 0)
                          : EdgeInsets.zero,
                      child: CustomText(
                        text: title.toString(),
                        color: textColor ?? DMUtil.getDC(),
                        fontSize: AppStyle.large.sp - 1.w,
                        alignCenter: true,
                        isEllipsis: true,
                      ),
                    ),
                  ),
              ],
              icon ?? const SizedBox.shrink(),
            ],
          ),
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(AppStyle.appBarHeight.w);
}

class AppBarWithRadius extends StatelessWidget {
  final bool enableBackIcon;
  final String? title;
  final bool? switchLang;
  final double backGroundHeight;
  final double paddingBottom;
  final bool isRegisterNurse;
  final VoidCallback? backFn;
  const AppBarWithRadius(
      {super.key,
      this.enableBackIcon = false,
      this.title,
      this.backGroundHeight = 200,
      this.paddingBottom = 70,
      this.isRegisterNurse = false,
      this.switchLang,
      this.backFn});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          AppImages.backgroundRadius,
          fit: BoxFit.fill,
          width: double.infinity,
          height: backGroundHeight.w,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w) +
              EdgeInsets.only(bottom: paddingBottom.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  if (enableBackIcon ||
                      (title == null && switchLang == null)) ...[
                    BackArrowButton(
                      fn: backFn,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                  const LogoWidget(
                    isWhite: true,
                    width: 60,
                    fit: BoxFit.contain,
                    height: 50,
                  ),
                ],
              ),
              if (title != null)
                InkWell(
                  onTap: () {
                    if (title.toString().contains("My Account") ||
                        title.toString().contains("حسابي")) {
                      Util.pushPage(const EditProfilePage(), context);
                    }
                  },
                  child: CustomText(
                    text: title.toString(),
                    color: DMUtil.getWC(),
                    fontWeight: FontWeight.w600,
                    fontSize: AppStyle.small.sp,
                  ),
                ),
              if (switchLang == true)
                SwitchLanguageWidget(
                  isRegisterNurse: isRegisterNurse,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class BackArrowButton extends StatelessWidget {
  final VoidCallback? fn;
  final Color? color;
  final Alignment? alignment;
  const BackArrowButton({
    super.key,
    this.fn,
    this.alignment,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
          onTap: fn ?? () => Navigator.of(context).pop(),
          child: Padding(
            padding: EdgeInsets.only(right: 3.w, left: 3.w, top: 0),
            child: Icon(
              Icons.arrow_back_ios,
              color: color ?? DMUtil.getWC(),
              size: 23.w,
            ),
          )),
    );
  }
}

class NotificationIcon extends StatelessWidget {
  final Color? color;
  final VoidCallback? fn;
  const NotificationIcon({super.key, this.color, this.fn});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fn ?? () => Util.pushPage(const NotificationsScreen(), context),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          SvgPicture.asset(
            AppImages.notification,
            width: 20.w,
            colorFilter:
                ColorFilter.mode(color ?? DMUtil.getPcSc(), BlendMode.srcIn),
          ),
          BlocBuilder<BookingBloc, BookingState>(
            builder: (ctx, state) {
              // int length = BookingBloc.get(ctx).bookingList.length;
              // length = 1;
              return const CircleGreenMark();
            },
          )
        ],
      ),
    );
  }
}

class CircleGreenMark extends StatelessWidget {
  final double size;
  final Color? color;
  const CircleGreenMark({super.key, this.size = 3, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: DMUtil.getWC()),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      margin: const EdgeInsets.only(right: 3),
      child: CircleAvatar(
        backgroundColor: color ?? DMUtil.getGreen(),
        radius: size.w,
      ),
    );
  }
}

class ProfileIcon extends StatelessWidget {
  final Color color;
  const ProfileIcon({super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Util.pushPage(const ProfileScreen(), context),
      child: Icon(
        Icons.account_circle_outlined,
        color: DMUtil.getWC(),
        size: 20.w,
      ),
    );
  }
}

class GrabberBottomSheet extends StatelessWidget {
  const GrabberBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        width: 50.w,
        height: 5.w,
        decoration: BoxDecoration(
          color: kBackGround,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
