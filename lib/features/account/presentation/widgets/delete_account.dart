import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/presentation/screens/login.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/core/utils/shared_pref.dart';
import 'package:icare/core/constants/constant.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is DeleteAccountSuccessState) {
          SnackBarBuilder.showFeedBackMessage(
              context, state.message, Colors.green);
          // Navigate to login screen and clear all routes
          Util.pushPageAndRemoveRoutes(const LoginScreen(), context);
        } else if (state is DeleteAccountFailedState) {
          SnackBarBuilder.showFeedBackMessage(
              context, state.message, Colors.red);
        }
      },
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          final bool isLoading = state is DeleteAccountLoadingState;

          return Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 50.w,
                ),
                SizedBox(height: 15.h),
                CustomText(
                  text: translate("profile.delete_account"),
                  color: kText1,
                  fontWeight: FontWeight.bold,
                  fontSize: AppStyle.average.sp,
                ),
                SizedBox(height: 10.h),
                CustomText(
                  text: translate("profile.delete_account_confirmation"),
                  color: kText1.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w400,
                  fontSize: AppStyle.small.sp,
                  alignCenter: true,
                  maxLine: 3,
                ),
                SizedBox(height: 25.h),
                if (isLoading)
                  const CircularProgressIndicator(color: Colors.red)
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        height: 40.h,
                        width: 120.w,
                        circular: 8,
                        color: Colors.red,
                        widget: CustomText(
                          text: translate("button.yes"),
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: AppStyle.small.sp,
                        ),
                        onPressed: () {
                          final userId = SharedPref()
                              .getPreferenceString(Constants.userId);
                          if (userId.isNotEmpty) {
                            AccountBloc.get(context)
                                .add(DeleteAccountEvent(userId: userId));
                          } else {
                            SnackBarBuilder.showFeedBackMessage(
                                context, "User ID not found", Colors.red);
                          }
                        },
                      ),
                      CustomButton(
                        height: 40.h,
                        width: 120.w,
                        circular: 8,
                        color: Colors.white,
                        sideColor: Colors.grey[300]!,
                        sideWidth: 1,
                        widget: CustomText(
                          text: translate("button.no"),
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontSize: AppStyle.small.sp,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
