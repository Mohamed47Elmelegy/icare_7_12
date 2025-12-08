// ignore_for_file: use_build_context_synchronously

import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/core/utils/sms_api.dart';
import 'package:icare/features/authentication/presentation/screens/verification_code.dart';


class ChangePhone extends StatelessWidget {
  const ChangePhone({super.key});

  static TextEditingController phoneTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DMUtil.getWC(),
      appBar: GlobalAppBar(
        backGroundColor: DMUtil.getWC(),
        title: !Util.checkUser()?"":translate("profile.change_phone"),
        leadingIcon: const BackArrowButton(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: AppStyle.paddingFromH.w),
        child: Column(
          children: [


            const SizedBox(height: 10,),
            CustomText(
              color: DMUtil.getD2C(),
              fontSize: AppStyle.average.sp + 1,
              fontWeight: FontWeight.w600,
              fontFamily: primaryFontBold,
              text: translate("profile.enter_main_phone"),
            ),
            const SizedBox(height: 6,),
            SizedBox(
              width: 240.w,
              child: CustomText(
                color: DMUtil.getD2C(),
                fontSize: AppStyle.average.sp - 1,
                fontFamily: primaryFontBold,
                text: translate("profile.please_phone"),
                maxLine: 2,
                alignCenter: true,
              ),
            ),

            const SizedBox(height: 30,),
            Row(
              children: [
                Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0,color: DMUtil.getD2C())
                  ),
                  alignment: Alignment.center,
                  child: CustomText(
                    text: " +966 ",
                    fontSize: AppStyle.small.sp,
                  ),
                ),
                Expanded(
                  child: CustomTextFromField(
                    height: 50,
                    hintText: "502441695",
                    radius: 0,
                    textEditingController: phoneTextEditingController,
                    validator: () {},
                    textInputType: TextInputType.phone,
                    prefixIcon: null,
                    cursorColor: kPrimary,
                    suffixIcon:  Icon(Icons.phone,color: DMUtil.getD2C(),),
                    obscureText: false,
                    isLabelError: false,
                    hasBorder: true,
                    borderWidth: 1,
                    borderColor: DMUtil.getD2C(),
                    labelText: translate("signup.phone"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40,),
            BlocBuilder<AccountBloc,AccountState>(
              builder:(ctx,state){
                // AccountBloc bloc = AccountBloc.get(ctx);
                // if(states==FetchStates.FAILED) return const Center(child: Text("an error occurred"),);
                return Align(
                  child: CustomButton(
                      height: 40.h,
                      width: double.infinity,
                      circular: 10,
                      widget: state is UpdateProfileState && state.response.isLoad==true? const Center(child: CircularProgressIndicator(color: Colors.white,),):
                      CustomText(
                        color: Colors.white,
                        fontSize: AppStyle.average.sp,
                        fontFamily: primaryFontBold,
                        text: translate("profile.change_phone"),
                      ),
                      color: DMUtil.getRED(),
                      onPressed: () async {
                        String ph = phoneTextEditingController.text.trim();
                        String phone = "+966$ph";
                        if(Util.validatePhoneInput(phone, context)==false) return;
                        if(await SmsApi.sendOtp(provider:ph,isEmail: false,ctx: context)){
                          Util.pushPage(PinCodeVerificationScreen(data: {
                            'phone':ph,
                          },isChangePhone: true,), context);
                        }else{
                          SnackBarBuilder.showFeedBackMessage(context, translate("toast.field_empty"), Colors.red);
                        }
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
