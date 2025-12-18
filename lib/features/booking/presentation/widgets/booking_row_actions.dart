// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/presentation/widgets/completed_booking_menu.dart';
import 'package:icare/features/booking/data/models/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/core/strings/enum/order_enum.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/account/data/data_sources/account_data_source.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/screens/patient_profile.dart';
import 'package:icare/features/account/presentation/widgets/save_patient_vitals_btn.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/today_monitoring_vitals.dart';

class BookingRowActions extends StatelessWidget {
  final Booking item;
  final NurseEntity orderNurse;
  const BookingRowActions({
    super.key,
    required this.item,
    required this.orderNurse,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, state) {
        var accountBloc = AccountBloc.get(ctx);
        var currentUser = accountBloc.currentUser;
        if (currentUser == null) return const SizedBox.shrink();

        // Check if order is completed
        if (OrderModel.getStatusViewCheck(item.status.toString()) ==
            ORDER_STATUS.COMPLETED) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CompletedBookingMenuWidget(
                item: item,
                orderNurse: orderNurse,
                currentUser: currentUser,
              ),
            ],
          );
        }

        // Show new button layout for ongoing orders (for patients only)
        if (Util.isCustomer()) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Call button
              Expanded(
                child: CustomButton(
                  height: 24.h,
                  width: double.infinity,
                  color: Colors.transparent,
                  sideColor: DMUtil.getPC(),
                  sideWidth: 1,
                  circular: 20,
                  widget: CustomText(
                    text: translate("order.call"),
                    fontSize: AppStyle.small.sp,
                    color: DMUtil.getPC(),
                    fontWeight: FontWeight.w500,
                  ),
                  onPressed: () => _handleCall(context),
                ),
              ),
              // Chat button
              SizedBox(width: 16.w),
              Expanded(
                child: CustomButton(
                  height: 24.h,
                  width: double.infinity,
                  color: Colors.transparent,
                  sideColor: DMUtil.getPC(),
                  sideWidth: 1,
                  circular: 20,
                  widget: CustomText(
                    text: translate("profile.chat"),
                    fontSize: AppStyle.small.sp,
                    color: DMUtil.getPC(),
                    fontWeight: FontWeight.w500,
                  ),
                  onPressed: () => _handleChat(context),
                ),
              ),
            ],
          );
        }

        // For nurses
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Call button
            Expanded(
              child: CustomButton(
                height: 24.h,
                width: double.infinity,
                color: Colors.transparent,
                sideColor: DMUtil.getPC(),
                sideWidth: 1,
                circular: 20,
                widget: CustomText(
                  text: translate("order.call"),
                  fontSize: AppStyle.small.sp,
                  color: DMUtil.getPC(),
                  fontWeight: FontWeight.w500,
                ),
                onPressed: () => _handleCall(context),
              ),
            ),
            SizedBox(width: 8.w),
            // Chat button
            Expanded(
              child: CustomButton(
                height: 24.h,
                width: double.infinity,
                color: Colors.transparent,
                sideColor: DMUtil.getPC(),
                sideWidth: 1,
                circular: 20,
                widget: CustomText(
                  text: translate("profile.chat"),
                  fontSize: AppStyle.small.sp,
                  color: DMUtil.getPC(),
                  fontWeight: FontWeight.w500,
                ),
                onPressed: () => _handleChat(context),
              ),
            ),
            SizedBox(width: 8.w),
            // Finish Order button (Navigate to Edit Patient)
            Expanded(
              child: CustomButton(
                height: 24.h,
                width: double.infinity,
                color: Colors.transparent,
                sideColor: DMUtil.getPC(),
                sideWidth: 1,
                circular: 20,
                widget: CustomText(
                  text: translate("order.complete_order"),
                  fontSize: AppStyle.small.sp,
                  color: DMUtil.getPC(),
                  fontWeight: FontWeight.w500,
                ),
                onPressed: () => _handleValuesWrapper(context),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleChat(BuildContext context) {
    String receiverName = "";
    String receiverID = "";
    if (Util.isCustomer()) {
      receiverName = item.nurseName.toString();
      receiverID = item.nurseID.toString();
    } else {
      receiverName = item.userName.toString();
      receiverID = item.userId.toString();
    }

    Util.openChat(
      context: context,
      receiverID: receiverID,
      receiverName: receiverName,
      chatRoomID: item.orderId.toString(),
    );
  }

  Future<void> _handleCall(BuildContext context) async {
    String? phoneNumber;
    if (Util.isCustomer()) {
      phoneNumber = orderNurse.userData?.phoneNumber;
    } else {
      // For nurse calling patient, we need to fetch user data first
      try {
        var patient = await UserServiceRemoteDataSource.getUserFullData(
            item.userId.toString());
        phoneNumber = patient.phoneNumber;
      } catch (e) {
        debugPrint("Error fetching patient phone: $e");
      }
    }

    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      await Util.makeCall(
        context: context,
        phoneNumber: phoneNumber,
      );
    }
  }

  Future<void> _handleValuesWrapper(BuildContext context) async {
    // Navigate directly to edit patient profile without permission check
    var accountBloc = AccountBloc.get(context);
    await accountBloc.switchCurrentUserWithPatientProfile(
        item.userId.toString(), 'customer');
    accountBloc.add(const FetchProfileDataEvent());

    // Create a GlobalKey to access the vitals widget state
    final vitalsKey = GlobalKey<TodayMonitoringVitalsState>();

    await Util.pushPage(
        PopScope(
          canPop: true,
          onPopInvoked: (didPop) async {
            if (didPop) {
              await _afterEditPatient(context, accountBloc, orderNurse);
            }
          },
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SavePatientVitalsAndCompleteBookingBtn(
              booking: item,
              vitalsKey: vitalsKey,
              onCompleted: () async {
                await _afterEditPatient(context, accountBloc, orderNurse,
                    pop: true);
              },
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: PatientProfile(
                isNurseEditMode: true,
                vitalsKey: vitalsKey,
                fnAfterNurseEdit: () async {
                  await _afterEditPatient(context, accountBloc, orderNurse,
                      pop: true);
                },
              ),
            ),
            backgroundColor: Colors.white,
          ),
        ),
        context);
  }

  _afterEditPatient(
      BuildContext context, AccountBloc accountBloc, NurseEntity orderNurse,
      {bool pop = false}) async {
    await accountBloc.switchCurrentUserWithPatientProfile(
        orderNurse.userData!.userId.toString(), 'nurse');

    ///will be change if nurse or assistant
    accountBloc.add(const FetchProfileDataEvent());
    await Future.delayed(const Duration(microseconds: 100));
    if (pop && context.mounted) Navigator.of(context).pop();
  }
}
