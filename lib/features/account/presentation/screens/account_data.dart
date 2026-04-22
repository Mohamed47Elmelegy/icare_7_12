import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/widgets/change_phone_section.dart';
import 'package:icare/features/account/presentation/widgets/secure_info.dart';
import 'package:icare/features/account/presentation/widgets/user_account_widget.dart';
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

            // ],
          ],
        ),
      ),
    );
  }
}
