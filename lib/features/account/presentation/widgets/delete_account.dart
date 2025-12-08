
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_event.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';
import 'package:icare/features/root_app/screens/root_screen.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocListener<AuthBloc,AuthState>(
        listener: (ctx,state){
          if(state is LogOutState)Util.pushPageAndRemoveRoutes(const RootScreen(), ctx);
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
                      text: translate("profile.attention"),
                      color: kText1,
                      fontWeight: FontWeight.w500,
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
                              fontWeight: FontWeight.w500,
                              fontSize: AppStyle.small.sp),
                          color: Colors.black,
                          onPressed: ()=> bloc.add(const LogOutEvent())),
                      CustomButton(
                          height: 30.h,
                          width: 100.w,
                          circular: 5,
                          widget: CustomText(
                              text: translate("button.no"),
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
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
