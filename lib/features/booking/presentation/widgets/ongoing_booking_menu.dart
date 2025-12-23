// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/chat/presentation/screens/main_conversation.dart';
import 'package:icare/features/locations/presentation/screens/set_and_get_coordinates.dart';
import 'package:icare/features/account/data/data_sources/account_data_source.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';
import 'package:icare/features/account/presentation/screens/patient_profile.dart';
import 'package:icare/features/account/presentation/widgets/save_profile_btn.dart';

class OnGoingBookingMenuWidget extends StatelessWidget {
  final Booking item;
  final NurseEntity orderNurse;
  const OnGoingBookingMenuWidget(
      {super.key, required this.item, required this.orderNurse});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (ctx, state) {
        if (state is UpdateOrderSuccessfullyState) {
          SnackBarBuilder.showFeedBackMessage(
              context, translate('toast.complete_order'), Colors.green);
          // Navigate back after completing the order
          Navigator.of(context).pop();
        } else if (state is OrderErrorState) {
          SnackBarBuilder.showFeedBackMessage(
              context, state.errors.toString(), Colors.red);
        } else {
          SnackBarBuilder.showFeedBackMessage(
              context, translate('toast.oops'), Colors.red);
        }
      },
      listenWhen: (ctx, state) =>
          state is UpdateOrderSuccessfullyState || state is OrderErrorState,
      child: Row(
        children: [
          if (!Util.isCustomer()) ...[
            InkWell(
              onTap: () async {
                var accountBloc = AccountBloc.get(context);
                await accountBloc.switchCurrentUserWithPatientProfile(
                    item.userId.toString(), 'customer');
                accountBloc.add(const FetchProfileDataEvent());
                await Util.pushPage(
                    PopScope(
                      canPop: true,
                      onPopInvoked: (didPop) async {
                        if (didPop) {
                          await _afterEditPatient(
                              context, accountBloc, orderNurse);
                        }
                      },
                      child: Scaffold(
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.centerFloat,
                        floatingActionButton: const SaveProfileBtn(),
                        body: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: PatientProfile(
                            isNurseEditMode: true,
                            fnAfterNurseEdit: () async {
                              await _afterEditPatient(
                                  context, accountBloc, orderNurse,
                                  pop: true);
                            },
                          ),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    context);
              },
              child: Tooltip(
                message: translate("booking.edit_patient_profile"),
                child: Icon(
                  Icons.account_circle,
                  color: DMUtil.getPC4(),
                  size: 20.w,
                ),
              ),
            ),
            const SizedBox(
              width: 3,
            ),
          ],
          PopupMenuButton(
            icon: Icon(
              Icons.info_outline,
              color: DMUtil.getPC4(),
              size: 20.w,
            ),
            itemBuilder: (_) => <PopupMenuItem<String>>[
              if (!Util.isCustomer())
                PopupMenuItem<String>(
                  value: 'complete_booking',
                  child: CustomText(
                      text: translate("order.complete_order"),
                      fontSize: AppStyle.small.sp),
                ),
              PopupMenuItem<String>(
                value: 'chat',
                child: CustomText(
                    text: translate("profile.chat"),
                    fontSize: AppStyle.small.sp),
              ),
              if (Util.isCustomer())
                PopupMenuItem<String>(
                  value: 'track',
                  child: CustomText(
                      text: translate("order.track_nurse"),
                      fontSize: AppStyle.small.sp),
                ),
            ],
            onSelected: (val) async {
              if (val.toString().trim() == "complete_booking") {
                BookingBloc.get(context).add(UpdateOrderEvent(
                  data: {
                    'booking_id': item.orderId,
                    'status': 'COMPLETED',
                  },
                ));
              }
              if (val.toString().trim() == "chat") {
                String receiverName = "";
                String receiverID = "";
                if (Util.isCustomer()) {
                  receiverName = item.nurseName.toString();
                  receiverID = item.nurseID.toString();
                } else {
                  receiverName = item.userName.toString();
                  receiverID = item.userId.toString();
                }
                Util.pushPage(
                    ConversationScreen(
                        receiverID: receiverID,
                        receiverName: receiverName,
                        chatRoomID: item.orderId.toString()),
                    context);
              }

              if (val.toString().trim() == "track") {
                var trackingNurse =
                    await UserServiceRemoteDataSource.getUserFullData(
                        orderNurse.userData!.userId.toString());
                Util.pushPage(
                    MapScreen(
                      isSet: true,
                      title: trackingNurse.userName.toString(),
                      latitude: trackingNurse.lat.toString(),
                      longitude: trackingNurse.long.toString(),
                      userID: trackingNurse.userId.toString(),
                      userImg: trackingNurse.image,
                    ),
                    context);
              }
            },
          ),
        ],
      ),
    );
  }

  _afterEditPatient(
      BuildContext context, AccountBloc accountBloc, NurseEntity orderNurse,
      {bool pop = false}) async {
    await accountBloc.switchCurrentUserWithPatientProfile(
        orderNurse.userData!.userId.toString(), 'nurse');

    ///will be change if nurse or assistant
    accountBloc.add(const FetchProfileDataEvent());
    await Future.delayed(const Duration(microseconds: 100));
    if (pop) Navigator.of(context).pop();
  }
}
