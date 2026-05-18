import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/home/presentation/widgets/request_company/gender_row.dart';
import 'package:icare/features/home/presentation/widgets/request_company/more_need.dart';
import 'package:icare/features/home/presentation/widgets/request_company/request_movment_level_select_drop_down.dart';
import 'package:icare/features/home/presentation/widgets/request_company/request_date_select_drop_down.dart';
import 'package:icare/features/home/presentation/widgets/request_company/request_need_to_select_drop_down.dart';
import 'package:icare/features/home/presentation/widgets/request_company/send_request_btn.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';

class RequestForm extends StatelessWidget {
  const RequestForm({super.key});
  static final TextEditingController fullnameTextEditingController =
      TextEditingController();
  static final TextEditingController nationalIDTextEditingController =
      TextEditingController();
  static final TextEditingController addressTextEditingController =
      TextEditingController();
  static final TextEditingController emailTextEditingController =
      TextEditingController();
  static final TextEditingController mainMedicalTextEditingController =
      TextEditingController();
  static final TextEditingController moreInfoMedicalTextEditingController =
      TextEditingController();
  static final TextEditingController phoneTextEditingController =
      TextEditingController();
  static final TextEditingController numberTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scrollbar(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GrabberBottomSheet(),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFromField(
                    hasBorder: true,
                    borderWidth: 1,
                    borderColor: DMUtil.getD2C(),
                    labelText: '',
                    height: 45,
                    hintText: translate("signup.full_name"),
                    radius: 10,
                    onChanged: (val) => BookingBloc.get(context).add(
                        UpdateRequestFormDataEvent(
                            data: {'full_name': val.toString()})),
                    onFieldSubmitted: (val) {},
                    textInputType: TextInputType.name,
                    textEditingController: fullnameTextEditingController,
                    validator: () {},
                    prefixIcon: null,
                    obscureText: false,
                    isLabelError: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFromField(
                    hasBorder: true,
                    borderWidth: 1,
                    borderColor: DMUtil.getD2C(),
                    labelText: '',
                    height: 45,
                    hintText: translate("signup.national_id"),
                    radius: 10,
                    onChanged: (val) => BookingBloc.get(context).add(
                        UpdateRequestFormDataEvent(
                            data: {'national_id': val.toString()})),
                    onFieldSubmitted: (val) {},
                    textInputType: TextInputType.number,
                    textEditingController: nationalIDTextEditingController,
                    validator: () {},
                    prefixIcon: null,
                    obscureText: false,
                    isLabelError: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFromField(
                    hasBorder: true,
                    borderWidth: 1,
                    borderColor: DMUtil.getD2C(),
                    labelText: '',
                    height: 45,
                    hintText: translate("signup.main_medical"),
                    radius: 10,
                    onChanged: (val) => BookingBloc.get(context).add(
                        UpdateRequestFormDataEvent(
                            data: {'main_medical': val.toString()})),
                    onFieldSubmitted: (val) {},
                    textInputType: TextInputType.text,
                    textEditingController: mainMedicalTextEditingController,
                    validator: () {},
                    prefixIcon: null,
                    obscureText: false,
                    isLabelError: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFromField(
                    hasBorder: true,
                    borderWidth: 1,
                    borderColor: DMUtil.getD2C(),
                    labelText: '',
                    height: 45,
                    hintText: translate("signup.phone"),
                    radius: 10,
                    onChanged: (val) => BookingBloc.get(context).add(
                        UpdateRequestFormDataEvent(
                            data: {'phone': val.toString()})),
                    onFieldSubmitted: (val) {},
                    textInputType: TextInputType.phone,
                    textEditingController: phoneTextEditingController,
                    validator: () {},
                    prefixIcon: null,
                    obscureText: false,
                    suffixIcon: Icon(
                      Icons.phone,
                      color: DMUtil.getPC(),
                      size: 20.w,
                    ),
                    isLabelError: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const GenderRowRequestForm(),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomText(
                    text: translate('icare.need_to'),
                    fontSize: AppStyle.average.sp - 2,
                  ),
                  const NeedToSelectDropDown(),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomText(
                    text: translate('icare.movement_level'),
                    fontSize: AppStyle.average.sp - 2,
                  ),
                  const MovmentLevelSelectDropDown(),
                  const SizedBox(
                    height: 20,
                  ),
                  const MoreNeedWidget(),
                  CustomText(
                    text: translate('icare.service_duration'),
                    fontSize: AppStyle.average.sp - 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CustomTextFromField(
                          hasBorder: true,
                          borderWidth: 1,
                          borderColor: DMUtil.getD2C(),
                          labelText: '',
                          height: 45,
                          hintText: '1',
                          radius: 10,
                          onChanged: (val) => BookingBloc.get(context).add(
                              UpdateRequestFormDataEvent(
                                  data: {'range_number': val.toString()})),
                          onFieldSubmitted: (val) {},
                          textInputType: TextInputType.number,
                          textEditingController: numberTextEditingController,
                          validator: () {},
                          prefixIcon: null,
                          obscureText: false,
                          isLabelError: false,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const RequestDateSelectDropDown(),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomText(
                    text: translate('icare.more_info'),
                    fontSize: AppStyle.average.sp - 2,
                  ),
                  CustomTextFromField(
                    hasBorder: true,
                    borderWidth: 1,
                    borderColor: DMUtil.getD2C(),
                    labelText: '',
                    height: 100,
                    hintText: translate("icare.more_info"),
                    radius: 10,
                    maxLines: 3,
                    onChanged: (val) => BookingBloc.get(context).add(
                        UpdateRequestFormDataEvent(
                            data: {'more_info': val.toString()})),
                    onFieldSubmitted: (val) {},
                    textInputType: TextInputType.text,
                    textEditingController: moreInfoMedicalTextEditingController,
                    validator: () {},
                    prefixIcon: null,
                    obscureText: false,
                    isLabelError: false,
                  ),
                  const SizedBox(
                    height: 280,
                  ),
                ],
              )),
        ),
        Positioned(
          bottom: 20.w,
          child: const SendRequestBtn(),
        ),
      ],
    );
  }
}
