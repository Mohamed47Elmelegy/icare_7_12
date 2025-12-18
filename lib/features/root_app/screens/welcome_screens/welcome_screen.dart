import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/presentation/widgets/already_have_account.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/root_app/bloc/root_event.dart';
import 'package:icare/features/root_app/bloc/root_state.dart';
import 'package:icare/features/root_app/screens/welcome_screens/first_screen.dart';
import 'package:icare/features/root_app/screens/welcome_screens/second_screen.dart';
import 'package:icare/features/root_app/screens/welcome_screens/third_screen.dart';
import 'package:icare/features/root_app/screens/welcome_screens/turn_on_notification.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DMUtil.getBackGround(),
      body: BlocBuilder<RootBloc, RootState>(
        builder: (ctx, state) {
          var bloc = RootBloc.get(ctx);
          return PageView.builder(
            controller: pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (indX) {
              if (indX > 2) {
                bloc.add(const ChangeIndex(index: 0, title: ""));
                Util.pushPageAndRemoveRoutes(
                    const TurnOnNotificationScreen(), context);
              } else {
                bloc.add(ChangeIndex(index: indX + 1, title: ""));
              }
            },
            itemBuilder: (ctx, index) {
              return Align(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (index == 0) ...[
                      const FirstScreen(),
                    ] else if (index == 1) ...[
                      const SecondScreen(),
                    ] else ...[
                      const ThirdScreen(),
                    ],
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DotIcon(selected: index == 0),
                        const SizedBox(
                          width: 5,
                        ),
                        DotIcon(selected: index == 1),
                        const SizedBox(
                          width: 5,
                        ),
                        DotIcon(selected: index == 2),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    CustomButton(
                        height: 40.w,
                        width: 240.w,
                        withShadow: true,
                        widget: CustomText(
                          text: translate("app_bar.get_started"),
                          fontSize: AppStyle.average.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        color: DMUtil.getPC(),
                        onPressed: () => Util.pushPage(
                            const TurnOnNotificationScreen(), context)),
                    const SizedBox(
                      height: 20,
                    ),
                    const AlreadyHaveAnAccountWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DotIcon extends StatelessWidget {
  final bool selected;
  const DotIcon({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Icon(
      selected ? Icons.circle : Icons.circle_outlined,
      size: 10.w,
      color: DMUtil.getPC(),
    );
  }
}
