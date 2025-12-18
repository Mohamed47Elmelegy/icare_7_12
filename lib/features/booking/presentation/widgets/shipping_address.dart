import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';

class ShippingAddress extends StatelessWidget {
  const ShippingAddress({super.key});

  static final TextEditingController cityTextEditingController =
      TextEditingController();
  static final TextEditingController addressTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (cityTextEditingController.text.isEmpty) {
      cityTextEditingController.text = Util.getCity();
    }
    if (addressTextEditingController.text.isEmpty) {
      addressTextEditingController.text = Util.getAddress();
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomText(
                text: translate('order.shipping_details'),
                color: kPrimary,
                fontSize: AppStyle.average.sp),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50.h,
              child: CustomTextFromField(
                  hintText: translate("profile.city"),
                  labelText: translate("profile.city"),
                  radius: 10,
                  textEditingController: cityTextEditingController,
                  validator: () {},
                  prefixIcon: null,
                  cursorColor: kPrimary,
                  hasBorder: true,
                  suffixIcon: const SizedBox(),
                  obscureText: false,
                  isLabelError: false),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 50.h,
              child: CustomTextFromField(
                  hintText: translate("profile.address"),
                  labelText: translate("profile.address"),
                  radius: 10,
                  textEditingController: addressTextEditingController,
                  validator: () {},
                  prefixIcon: null,
                  cursorColor: kPrimary,
                  hasBorder: true,
                  suffixIcon: const SizedBox(),
                  obscureText: false,
                  isLabelError: false),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              height: 34.h,
              width: 100.w,
              circular: 0,
              widget: CustomText(
                text: translate("button.ok"),
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: AppStyle.average.sp,
              ),
              color: kPrimary,
              onPressed: () {
                if (addressTextEditingController.text.trim().isNotEmpty &&
                    cityTextEditingController.text.trim().isNotEmpty) {
                  // Navigator.pop(context,Shipping(city: cityTextEditingController.text.trim(),address1: addressTextEditingController.text.trim()));
                } else {
                  SnackBarBuilder.showFeedBackMessage(
                      context, translate("toast.field_empty"), Colors.red);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
