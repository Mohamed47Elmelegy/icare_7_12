import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/services_bloc.dart';
import 'package:icare/features/account/presentation/bloc/services_event.dart';
import 'package:icare/features/booking/data/data_sources/order_remote_data_source.dart';
import 'package:icare/features/booking/domain/entities/request_entity.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/widgets/order_details/order_description.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_dialogs.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';

class RequestDetailsScreen extends StatelessWidget {
  final bool showActions;
  final String id;
  final RequestEntity requestEntity;
  const RequestDetailsScreen(
      {super.key,
      this.showActions = false,
      required this.id,
      required this.requestEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DMUtil.getPC(),
      appBar: GlobalAppBar(
        backGroundColor: DMUtil.getPC(),
        title: translate('home.view_all_offer'),
        textColor: DMUtil.getWC(),
        leadingIcon: BackArrowButton(
          color: DMUtil.getWC(),
        ),
      ),
      body: Container(
        padding: AppStyle.globalPadding,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
            color: DMUtil.getWC(),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(text: "    #$id", fontSize: AppStyle.average.sp),
              RequestDetails(txt: '''
                  ${translate('order.patient_phone')} ${requestEntity.userPhone} \n
                  ${requestEntity.userNote}

              '''),
              const Divider(
                height: 30,
              ),
              CustomText(
                  text: translate('order.companie_offers'),
                  fontSize: AppStyle.average.sp),
              if (requestEntity.requestOfferList.isEmpty) ...[
                Container(
                    margin: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: CustomText(
                      text: translate('order.no_offers'),
                      fontSize: AppStyle.average.sp,
                    )),
              ] else
                ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 20,
                        ),
                    itemCount: requestEntity.requestOfferList.length,
                    itemBuilder: (ctx, index) {
                      var item = requestEntity.requestOfferList[index];
                      int acceptedIndex = requestEntity.requestOfferList
                          .indexWhere((val) => val.status == 'accepted');
                      bool ifAcceptedOne = acceptedIndex != -1;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CustomText(
                                text: item.companyName,
                                fontSize: AppStyle.average.sp,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              CustomText(
                                text:
                                    "${item.offerPrice}${translate('icare.le')}",
                                fontSize: AppStyle.average.sp,
                              ),
                            ],
                          ),
                          if (item.status == 'accepted') ...[
                            CustomText(
                              text: translate('order.accepted'),
                              fontSize: AppStyle.average.sp,
                              color: kPrimary,
                            ),
                          ] else if (!ifAcceptedOne)
                            CustomButton(
                              height: 24.w,
                              width: 90.w,
                              widget: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: CustomText(
                                  text: translate("button.confirm"),
                                  fontSize: AppStyle.average.sp,
                                  color: kPrimary,
                                ),
                              ),
                              sideColor: kPrimary,
                              sideWidth: 1,
                              color: kWhite,
                              onPressed: () async {
                                final res =
                                    await CustomDialogs.sureToSubmit(context);
                                if (res) {
                                  final result =
                                      await OrderRemoteDataSource.acceptOffer(
                                          data: {
                                        'offer_id': item.id,
                                      });
                                  if (!context.mounted) return;
                                  if (result == true) {
                                    SnackBarBuilder.showFeedBackMessage(
                                        context,
                                        translate('toast.gmail_send'),
                                        kPrimary);
                                    ServicesBloc.get(context).add(
                                        const FetchAllNotificationsEvent());
                                    BookingBloc.get(context)
                                        .add(const FetchAllOrderEvent());
                                    Navigator.of(context).pop();
                                  } else {
                                    SnackBarBuilder.showFeedBackMessage(
                                        context, result, Colors.red);
                                  }
                                }
                              },
                            ),
                        ],
                      );
                    }),
            ],
          ),
        ),
      ),
    );
  }
}
