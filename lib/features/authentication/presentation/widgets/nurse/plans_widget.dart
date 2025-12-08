// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/widgets/notifications_widgets/dot_dashed_widget.dart';
import 'package:icare/features/root_app/screens/root_screen.dart';
import 'package:icare/features/setting/presentation/screens/web_view.dart';
import 'package:icare/features/shared_widgets/align_child_by_row.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class PlansWidget extends StatelessWidget {
  const PlansWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DMUtil.getWC(),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        // decoration: BoxDecoration(
        //     color: DMUtil.getWC(),
        //     borderRadius: const BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25))
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.w,
            ),
            CustomText(
              text: translate("nurse.subscribe_plans"),
              fontWeight: FontWeight.w600,
              fontSize: AppStyle.average.sp,
              color: DMUtil.getText(),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              child: DotWidget(
                dashWidth: 4,
                totalWidth: 330.w,
              ),
            ),

            SizedBox(
              height: 20.w,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PlanWidget(
                  planTitle: "Plan 1",
                  planFeatures: [
                    'Daily medications',
                    'Daily medications',
                    'Daily medications'
                  ],
                ),
                PlanWidget(
                  planTitle: "Plan 1",
                  planFeatures: [
                    'Daily medications',
                    'Daily medications',
                    'Daily medications'
                  ],
                ),
              ],
            ),
            // SizedBox(height: 10.w,),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     PlanWidget(
            //       planTitle: "Plan 1",
            //       planFeatures: ['Daily medications','Daily medications','Daily medications'],
            //     ),
            //     PlanWidget(
            //       planTitle: "Plan 1",
            //       planFeatures: ['Daily medications','Daily medications','Daily medications'],
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

class PlanWidget extends StatelessWidget {
  final String planTitle;
  final List<String> planFeatures;
  const PlanWidget(
      {super.key, required this.planTitle, required this.planFeatures});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: BorderSide(width: 1, color: DMUtil.getD2C())),
      child: Container(
        width: 160.w,
        height: 145.w,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlignChildRow(
              child: CustomText(
                text: planTitle,
                fontWeight: FontWeight.w600,
                fontSize: AppStyle.small.sp,
                color: DMUtil.getText(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ...planFeatures.map((i) => Column(
                  children: [
                    CustomText(
                      text: i.toString(),
                      fontSize: AppStyle.small.sp,
                      color: DMUtil.getD2C(),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                )),
            SizedBox(
              height: 10.w,
            ),
            CustomButton(
              height: 25.w,
              width: 95.w,
              widget: HtmlWidget(
                '''
              <a style="color:#ffffff;" href="https://checkout.kashier.io/?merchantId=MID-22182-619&
        orderId=65d0cc2e66eda8001387b842&
        amount=50&
        currency=EGP&
        hash=ORDER-HASH&
        mode=ORDER-MODE&
        merchantRedirect=http://icarebackend.softifytechs.com/&
        serverWebhook=https://softifytechs.com/icare_backend/api/v1/kashierWebhook&
        metaData=ORDER-META-DATA&
        paymentRequestId=INV-2218261905&
        allowedMethods=ORDER-ALLOWED-METHODS&
        defaultMethod=ORDER-DEFAULT-METHOD&
        failureRedirect=ORDER-FAILURE-REDIRECT&
        redirectMethod=ORDER-REDIRECT-METHOD&
        connectedAccount=ORDER-CONNECTED-ACCOUNT&
        brandColor=ORDER-BRAND-COLOR&
        display=ORDER-DISPLAY&
        manualCapture=ORDER-AUTH&
        customer=Customer-data&
        saveCard=customer-saveCard&
        interactionSource=Ecommerce&
        enable3DS=true
        "
        > ${translate("nurse.subscribe")} </a>
              ''',
                customStylesBuilder: (element) {
                  if (element.classes.contains('foo')) {
                    return {'color': 'red'};
                  }

                  return null;
                },

                customWidgetBuilder: (element) {
                  return null;
                },

                // this callback will be triggered when user taps a link
                onTapUrl: (url) async {
                  debugPrint('tapped ${url.trim()}');
                  await Util.pushPage(
                      WebViewScreen(
                        title: translate("nurse.subscribe"),
                        url: url.trim(),
                      ),
                      context);
                  Util.pushPageAndRemoveRoutes(const RootScreen(), context);
                  return Future.value(true);
                },
                // select the render mode for HTML body
                // by default, a simple `Column` is rendered
                // consider using `ListView` or `SliverList` for better performance
                renderMode: RenderMode.column,

                // set the default styling for text
                textStyle: const TextStyle(fontSize: 14),
              ),
              // widget: CustomText(
              //   text: translate("nurse.subscribe"),
              //   fontSize: AppStyle.small.sp-2,
              //   fontWeight: FontWeight.w600,
              //   alignCenter: true,
              //   color: DMUtil.getWC(),
              // ),
              color: DMUtil.getPC(),
              onPressed: () async {
                // String url = await KashierClass.generateURL();
                // await Util.pushPage(const WebViewScreen(title: "",url: 'https://icarebackend.softifytechs.com/test/page',), context);
                // Util.pushPageAndRemoveRoutes(const RootScreen(), context);
                // Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
