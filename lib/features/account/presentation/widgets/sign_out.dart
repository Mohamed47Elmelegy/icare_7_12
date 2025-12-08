
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_event.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/splash.dart';

class SignOut extends StatelessWidget {
  const SignOut({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocListener<AuthBloc,AuthState>(
        listener: (ctx,state){
          if(state is LogOutState) {
            AccountBloc.get(context).currentUser = null;
            Util.pushPageAndRemoveRoutes(const SplashScreen(), context);
          }
        },
        listenWhen: (ctx,state){
          return state is LogOutState;
        },
        child: BlocBuilder<AuthBloc,AuthState>(
          builder: (cxt,state){
            var bloc = AuthBloc.get(cxt);
            return Container(
              height: 180.h,
              width: 400.w,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomText(
                      text: translate("activity_setting.sure_signout"),
                      color: kText1,
                      fontFamily: primaryFontBold,
                      fontSize: AppStyle.average.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                          height: 30.h,
                          width: 100.w,
                          circular: 5,
                          widget: CustomText(
                              text: translate("button.yes"),
                              color: Colors.white,
                              fontFamily: primaryFontSemiBold,
                              fontSize: AppStyle.small.sp),
                          color: DMUtil.getPC(),
                          onPressed: (){
                            AccountBloc.get(context).add(const SwitchProfileStatusEvent(isOnline: true));
                            bloc.add(const LogOutEvent());
                          }),
                      CustomButton(
                          height: 30.h,
                          width: 100.w,
                          circular: 5,
                          widget: CustomText(
                              text: translate("button.no"),
                              color: Colors.red,
                              fontFamily: primaryFontSemiBold,
                              fontSize: AppStyle.small.sp),
                          color: Colors.white,
                          sideWidth: 1,
                          sideColor: Colors.black45,
                          onPressed: ()=>Navigator.of(context).pop()),
                    ],
                  ),
                ],
              ),
            );
          },
        )
    );
  }
}
