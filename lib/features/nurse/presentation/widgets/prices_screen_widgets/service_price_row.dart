import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';

class ServicePriceRowWithModify extends StatelessWidget {
  final int serviceID;
  final String serviceName;
  final String price;
  const ServicePriceRowWithModify(
      {super.key,
      required this.serviceID,
      required this.price,
      required this.serviceName});

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: serviceName,
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        BlocBuilder<AccountBloc, AccountState>(
          builder: (ctx, state) {
            var bloc = AccountBloc.get(ctx);
            bool enableUpdateService = bloc.currentModifyService == serviceID;
            if (enableUpdateService) {
              return Row(
                children: [
                  SizedBox(
                    width: 90.w,
                    child: CustomTextFromField(
                      hasBorder: true,
                      borderWidth: 1,
                      borderColor: DMUtil.getD2C(),
                      labelText: '',
                      height: 40,
                      hintText: " ${translate("icare.le")}",
                      radius: 10,
                      smallPadding: true,
                      onChanged: (val) {},
                      onFieldSubmitted: (val) {},
                      textEditingController: textEditingController,
                      validator: () {},
                      prefixIcon: null,
                      obscureText: false,
                      suffixIcon: null,
                      isLabelError: false,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                      onTap: () => bloc.add(ModifyCurrentService(
                          item: ServicesModel(
                              id: serviceID,
                              value: double.tryParse(
                                          textEditingController.text.trim()) !=
                                      null
                                  ? textEditingController.text.trim()
                                  : price))),
                      child: CircleAvatar(
                        radius: 10.w,
                        backgroundColor: DMUtil.getWC(),
                        child: Icon(
                          Icons.check,
                          size: 15.w,
                          color: DMUtil.getPC(),
                        ),
                      )),
                ],
              );
            }
            return Row(
              children: [
                if (!Util.isDoctor())
                  CustomText(
                    text: "$price ${translate("icare.le")}",
                    fontSize: AppStyle.small.sp,
                    fontWeight: FontWeight.w600,
                    color: DMUtil.getD2C(),
                  ),
                if (bloc.enableUpdate) ...[
                  if (!Util.isDoctor()) ...[
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                        onTap: () => bloc
                            .add(EnableModifyCurrentService(item: serviceID)),
                        child: CircleAvatar(
                          radius: 10.w,
                          backgroundColor: DMUtil.getWC(),
                          child: Icon(
                            Icons.edit,
                            size: 15.w,
                            color: DMUtil.getPC(),
                          ),
                        )),
                  ],
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                      onTap: () => bloc.add(ModifyCurrentService(
                          item: ServicesModel(id: serviceID, value: price),
                          isRemove: true)),
                      child: CircleAvatar(
                        radius: 10.w,
                        backgroundColor: DMUtil.getWC(),
                        child: Icon(
                          Icons.remove,
                          size: 15.w,
                          color: DMUtil.getRED(),
                        ),
                      )),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class ServicePriceRow extends StatelessWidget {
  final int serviceID;
  final String serviceName;
  final String price;
  const ServicePriceRow(
      {super.key,
      required this.serviceID,
      required this.price,
      required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => BookingBloc.get(context).add(UpdateBookingServiceListEvent(
          service:
              ServicesModel(id: serviceID, value: price, name: serviceName))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: serviceName,
            fontSize: AppStyle.small.sp,
            fontWeight: FontWeight.w600,
            color: DMUtil.getDC(),
          ),
          CustomText(
            text: "$price ${translate("icare.le")}",
            fontSize: AppStyle.small.sp,
            fontWeight: FontWeight.w600,
            color: DMUtil.getD2C(),
          ),
          BlocBuilder<BookingBloc, BookingState>(
            builder: (ctx, state) {
              var bloc = BookingBloc.get(ctx);
              int serviceIndex = bloc.orderServiceList
                  .indexWhere((element) => element.id == serviceID);
              bool selected = serviceIndex != -1;
              return CircleAvatar(
                radius: 14.w,
                backgroundColor: selected ? DMUtil.getPC() : DMUtil.getWC(),
                child: Icon(
                  Icons.check,
                  size: 17.w,
                  color: selected ? DMUtil.getWC() : DMUtil.getPC(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
