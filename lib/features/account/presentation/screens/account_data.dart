import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/widgets/change_phone_section.dart';
import 'package:icare/features/account/presentation/widgets/delete_account_widget.dart';
import 'package:icare/features/account/presentation/widgets/secure_info.dart';
import 'package:icare/features/account/presentation/widgets/user_account_widget.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AccountDataScreen extends StatelessWidget {
  const AccountDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DMUtil.getBackGround(),
      appBar: GlobalAppBar(
        backGroundColor: DMUtil.getWC(),
        title: translate("profile.profile"),
        whiteLogo: true,
        leadingIcon: const BackArrowButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const UserAccountWidget(),

            SizedBox(
              height: 10.w,
            ),
            const SecureInfo(),

            const Divider(
              height: 1,
            ),

            const ChangePhoneSection(),

            // if(Platform.isIOS)...[
            Container(
              color: DMUtil.getWC(),
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 10.w),
              padding: EdgeInsets.symmetric(
                  horizontal: AppStyle.paddingFromH.w - 4, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    text: translate("profile.delete_account"),
                    color: DMUtil.getD2C(),
                    fontWeight: FontWeight.w600,
                    fontSize: AppStyle.average.sp + 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    text: translate("profile.we_ar_sad_for_leave"),
                    fontSize: AppStyle.verySmall.sp,
                    color: DMUtil.getD2C().withOpacity(0.8),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const DeleteAccountWidget(),
                ],
              ),
            ),
            // ],
          ],
        ),
      ),
    );
  }
}
