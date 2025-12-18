// ignore_for_file: use_build_context_synchronously

import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/widgets/nurse_widgets/add_new_value.dart';
import 'package:icare/features/booking/data/data_sources/order_remote_data_source.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/widgets/thanks_order_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:icare/features/account/presentation/widgets/delete_account.dart';
import 'package:icare/features/account/presentation/widgets/sign_out.dart';
import 'package:icare/features/booking/presentation/widgets/sure_to_cancel_order.dart';
import 'package:icare/features/booking/presentation/widgets/shipping_address.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';
import 'package:icare/features/shared_widgets/sure_to_delete_widget.dart';
import 'package:icare/features/shared_widgets/sure_to_submit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomDialogs {
  static cancelOrderDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          backgroundColor: Colors.transparent,
          child: CancelOrderWidget(),
        );
      },
    );
  }

  //for nurse
  static acceptLocationPermission(BuildContext context) async {
    if (!Util.checkUser() || Util.isCustomer()) return;
    if (await Permission.location.isGranted) return;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(40.w),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(6),
                child: SizedBox(
                  height: 200.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: translate("toast.background_location"),
                        color: Colors.black,
                        fontSize: AppStyle.small.sp,
                        maxLine: 3,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton(
                            height: 30.h,
                            width: 110.w,
                            widget: CustomText(
                              text: translate("button.ok"),
                              color: Colors.white,
                              fontSize: AppStyle.small.sp - 1,
                            ),
                            color: DMUtil.getPC(),
                            onPressed: () async {
                              await LocationUtil.checkLocationPermission();
                              Navigator.pop(ctx);
                            },
                          ),
                          CustomButton(
                            height: 30.h,
                            width: 110.w,
                            widget: CustomText(
                              text: translate("button.cancel"),
                              color: Colors.white,
                              fontSize: AppStyle.small.sp - 1,
                            ),
                            color: DMUtil.getPC(),
                            onPressed: () => Navigator.pop(ctx),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  static signOut(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return const Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              backgroundColor: Colors.transparent,
              child: SignOut());
        });
  }

  static deleteAccount(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return const Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              backgroundColor: Colors.transparent,
              child: DeleteAccount());
        });
  }

  static shippingAddress(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return const Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              backgroundColor: Colors.transparent,
              child: ShippingAddress());
        });
  }

  static sureToSubmit(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return const Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              backgroundColor: Colors.transparent,
              child: SureToSubmitWidget());
        });
  }

  static sureToDelete(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return const Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              backgroundColor: Colors.transparent,
              child: SureToDeleteWidget());
        });
  }

  static thanksOrder(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return const Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              backgroundColor: Colors.transparent,
              child: ThanksOrderWidget());
        });
  }

  static viewImage(BuildContext context, String img) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              backgroundColor: Colors.transparent,
              child: SizedBox(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.close,
                        color: kPrimary,
                      ),
                    ),
                  ),
                  Image.network(
                    img,
                    width: double.infinity,
                    height: 500.h,
                  ),
                ],
              )));
        });
  }

  static addComment(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return const Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            backgroundColor: Colors.transparent,
            // child: AddCommentsWidget(item:item),
          );
        });
  }

  static addNewValue(BuildContext context, {String? placeholderValue}) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            backgroundColor: Colors.transparent,
            child: AddNewOptionValue(
              placeHolderValue: placeholderValue,
            ),
          );
        });
  }

  static patientGiveAccessToEditProfile(BuildContext context) async {
    if (!Util.checkUser() || !Util.isCustomer()) return;
    BookingBloc bookingBloc = BookingBloc.get(context);
    if (bookingBloc.checkIfExistBookingOngoingAndNurseCanNotEdit() == false) {
      return;
    }
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(40.w),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(6),
                child: SizedBox(
                  height: 200.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: translate("icare.give_nurse_access"),
                        color: Colors.black,
                        fontSize: AppStyle.small.sp,
                        maxLine: 3,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            height: 30.h,
                            width: 110.w,
                            widget: CustomText(
                              text: translate("button.ok"),
                              color: Colors.white,
                              fontSize: AppStyle.small.sp - 1,
                            ),
                            color: DMUtil.getPC(),
                            onPressed: () async {
                              bool res = await OrderRemoteDataSource
                                  .giveAccessEditProfile();
                              if (res) {
                                bookingBloc.add(const FetchAllOrderEvent());
                                SnackBarBuilder.showFeedBackMessage(
                                    context,
                                    translate('toast.give_access_success'),
                                    DMUtil.getGreen());
                              } else {
                                SnackBarBuilder.showFeedBackMessage(context,
                                    translate('toast.oops'), DMUtil.getRED());
                              }
                              Navigator.pop(ctx);
                            },
                          ),
                          // CustomButton(
                          //   height: 30.h,
                          //   width: 110.w,
                          //   widget: CustomText(
                          //     text: translate("button.cancel"),
                          //     color: Colors.white,
                          //     fontSize: AppStyle.small.sp - 1,
                          //   ),
                          //   color: DMUtil.getPC(),
                          //   onPressed: () => Navigator.pop(ctx),
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
