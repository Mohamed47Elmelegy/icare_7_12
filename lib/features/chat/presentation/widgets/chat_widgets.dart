import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String timeShow;
  final String senderName;
  const MessageTile(
      {super.key,
      required this.message,
      required this.sendByMe,
      required this.timeShow,
      required this.senderName});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          Util.getLang() == "ar" ? TextDirection.ltr : TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.only(
            top: 5,
            bottom: 5,
            left: sendByMe ? 10 : 10,
            right: sendByMe ? 10 : 10),
        alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment:
                  sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (sendByMe == false) ...[
                  Image.asset(
                    AppImages.nurse,
                    height: 28.w,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
                Container(
                    margin: sendByMe
                        ? const EdgeInsets.only(left: 10)
                        : const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.only(
                        top: 7, bottom: 7, left: 16, right: 16),
                    decoration: BoxDecoration(
                        borderRadius: sendByMe
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(23),
                                topRight: Radius.circular(23),
                                bottomLeft: Radius.circular(23))
                            : const BorderRadius.only(
                                topLeft: Radius.circular(23),
                                topRight: Radius.circular(23),
                                bottomRight: Radius.circular(23)),
                        color: sendByMe ? DMUtil.getPC2() : DMUtil.getWC()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                            height: message.length < 60 ? 20.h : 65.h,
                            width: message.length < 10 ? 70.w : 160.w,
                            child: SingleChildScrollView(
                              child: CustomText(
                                text: message,
                                color:
                                    sendByMe ? DMUtil.getWC() : DMUtil.getPC2(),
                                fontSize: AppStyle.small.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomText(
                          text: timeShow,
                          color: Colors.black38,
                          fontSize: AppStyle.verySmall.sp - 1,
                        ),
                      ],
                    )),
                if (sendByMe) ...[
                  const SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    AppImages.avatar,
                    height: 28.w,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
