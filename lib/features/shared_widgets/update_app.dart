import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/root_app/screens/root_screen.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:upgrader/upgrader.dart';

class UpdateAppScreen extends StatefulWidget {
  const UpdateAppScreen({super.key});

  @override
  State<UpdateAppScreen> createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {
  @override
  void initState() {
    if (Upgrader.sharedInstance.isUpdateAvailable() == false) {
      if (mounted) Util.pushPageAndRemoveRoutes(const RootScreen(), context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DMUtil.getWC(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: AppStyle.paddingFromH.w,
        ),
        child: Column(
          children: [
            SizedBox(
              height: AppStyle.paddingFromTop.h + 100,
            ),
            // const SwitchLanguageWidget(),
            Card(
                color: DMUtil.getWC(),
                elevation: 15,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icons/logo.png",
                        width: 200,
                        fit: BoxFit.contain,
                        height: 150,
                      ),
                      // const LogoWidget(isWhite: true,width: 200,fit: BoxFit.contain,height: 150,),
                      CustomText(
                        text: translate("app_bar.new_version_from"),
                        color: DMUtil.getDC(),
                        fontSize: AppStyle.average.sp - 1,
                        fontWeight: FontWeight.w600,
                        alignCenter: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomText(
                        text:
                            "${translate("app_bar.update_to_enjoy")} (${Upgrader.sharedInstance.currentAppStoreVersion.toString()})",
                        color: DMUtil.getD2C(),
                        fontSize: AppStyle.small.sp,
                        maxLine: 2,
                        alignCenter: true,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomButton(
                        height: 45.h,
                        width: double.infinity,
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomText(
                                text: translate("app_bar.update_app"),
                                color: Colors.white,
                                fontSize: AppStyle.average.sp - 1,
                                fontWeight: FontWeight.w600,
                                alignCenter: true,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: DMUtil.getWC(),
                              size: 18.w,
                            )
                          ],
                        ),
                        color: DMUtil.getPC(),
                        onPressed: () => Util.goToStore(),
                      ),
                    ],
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
