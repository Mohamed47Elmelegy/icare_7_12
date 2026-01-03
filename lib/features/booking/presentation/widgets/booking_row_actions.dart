// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/order_completion_validator.dart';
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
                  height: 20.h,
                  width: double.infinity,
                  color: Colors.transparent,
                  sideColor: DMUtil.getPC(),
                  sideWidth: 1,
                  circular: 16,
                  widget: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomText(
                      text: translate("order.call"),
                      fontSize: AppStyle.verySmall.sp,
                      color: DMUtil.getPC(),
                      fontWeight: FontWeight.w500,
                      maxLine: 1,
                    ),
                  ),
                  onPressed: () => _handleCall(context),
                ),
              ),
              // Chat button
              SizedBox(width: 6.w),
              Expanded(
                child: CustomButton(
                  height: 20.h,
                  width: double.infinity,
                  color: Colors.transparent,
                  sideColor: DMUtil.getPC(),
                  sideWidth: 1,
                  circular: 16,
                  widget: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomText(
                      text: translate("profile.chat"),
                      fontSize: AppStyle.verySmall.sp,
                      color: DMUtil.getPC(),
                      fontWeight: FontWeight.w500,
                      maxLine: 1,
                    ),
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
                height: 20.h,
                width: double.infinity,
                color: Colors.transparent,
                sideColor: DMUtil.getPC(),
                sideWidth: 1,
                circular: 16,
                widget: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustomText(
                    text: translate("order.call"),
                    fontSize: AppStyle.verySmall.sp,
                    color: DMUtil.getPC(),
                    fontWeight: FontWeight.w500,
                    maxLine: 1,
                  ),
                ),
                onPressed: () => _handleCall(context),
              ),
            ),
            SizedBox(width: 6.w),
            // Chat button
            Expanded(
              child: CustomButton(
                height: 20.h,
                width: double.infinity,
                color: Colors.transparent,
                sideColor: DMUtil.getPC(),
                sideWidth: 1,
                circular: 16,
                widget: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustomText(
                    text: translate("profile.chat"),
                    fontSize: AppStyle.verySmall.sp,
                    color: DMUtil.getPC(),
                    fontWeight: FontWeight.w500,
                    maxLine: 1,
                  ),
                ),
                onPressed: () => _handleChat(context),
              ),
            ),
            SizedBox(width: 6.w),
            // Finish Order button (Navigate to Edit Patient)
            Expanded(
              child: CustomButton(
                height: 20.h,
                width: double.infinity,
                color: Colors.transparent,
                sideColor: DMUtil.getPC(),
                sideWidth: 1,
                circular: 16,
                widget: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustomText(
                    text: translate("order.complete_order"),
                    fontSize: AppStyle.verySmall.sp,
                    color: DMUtil.getPC(),
                    fontWeight: FontWeight.w500,
                    maxLine: 1,
                  ),
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
    // Step 1: Get nurse's current location
    try {
      // Show loading indicator
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Get current position - FORCE FRESH LOCATION (no cache)
      Position nursePosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
          // Force fresh location on Android
          distanceFilter: 0,
        ),
      );

      // Verify location is fresh (not older than 30 seconds)
      final locationAge = DateTime.now().difference(nursePosition.timestamp);
      if (locationAge.inSeconds > 30) {
        debugPrint(
            '⚠️ Location is cached (${locationAge.inSeconds}s old). Retrying...');

        // Try again to get fresh location
        nursePosition = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 15),
          ),
        );
      }

      debugPrint(
          '📍 Fresh location obtained: ${nursePosition.latitude}, ${nursePosition.longitude}');
      debugPrint('🕐 Location timestamp: ${nursePosition.timestamp}');
      debugPrint('📏 Location accuracy: ${nursePosition.accuracy}m');

      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();

      // Step 2: Validate location using OrderCompletionValidator
      final validationResult =
          await OrderCompletionValidator.validateCompletion(
        booking: item,
        nursePosition: nursePosition,
      );

      // Step 3: Handle validation result
      if (!validationResult.isValid) {
        // Show error dialog with distance information
        if (context.mounted) {
          _showLocationErrorDialog(
            context: context,
            message: validationResult.message ?? 'Location validation failed',
            distance: validationResult.distance,
          );
        }
        return; // Stop execution - don't allow completion
      }

      // Step 4: Location validated - proceed with order completion
      debugPrint(
          '✅ Location validated. Distance: ${validationResult.distance?.toInt()}m');

      // Store nurse location for backend
      final nurseLocation = {
        'latitude': nursePosition.latitude,
        'longitude': nursePosition.longitude,
        'distance': validationResult.distance,
      };

      // Navigate to edit patient profile
      await _proceedToPatientProfile(context, nurseLocation);
    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Handle location errors
      if (context.mounted) {
        String errorMessage =
            'Unable to get your location. Please check GPS settings.';

        if (e.toString().contains('Location services are disabled')) {
          errorMessage = 'Please enable location services to complete orders.';
        } else if (e.toString().contains('denied')) {
          errorMessage =
              'Location permission denied. Please grant permission in settings.';
        }

        _showLocationErrorDialog(
          context: context,
          message: errorMessage,
        );
      }
      debugPrint('❌ Location error: $e');
    }
  }

  void _showLocationErrorDialog({
    required BuildContext context,
    required String message,
    double? distance,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: CustomText(
          text: translate('order.location_required'),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: message,
              fontSize: 14,
            ),
            if (distance != null) ...[
              SizedBox(height: 12.h),
              CustomText(
                text:
                    '${translate('order.current_distance')}: ${OrderCompletionValidator.formatDistance(distance)}',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: DMUtil.getPC(),
              ),
              SizedBox(height: 8.h),
              CustomText(
                text:
                    '${translate('order.required_distance')}: ${OrderCompletionValidator.STRICT_RANGE_METERS.toInt()}m',
                fontSize: 12,
                color: Colors.grey,
              ),
            ],
          ],
        ),
        actions: [
          CustomButton(
            height: 32.h,
            width: 80.w,
            color: DMUtil.getPC(),
            circular: 8,
            widget: CustomText(
              text: translate('general.ok'),
              color: Colors.white,
              fontSize: 14,
            ),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _proceedToPatientProfile(
    BuildContext context,
    Map<String, dynamic> nurseLocation,
  ) async {
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
              healthcareProviderId:
                  (orderNurse.userData?.userId ?? orderNurse.userId)
                          ?.toString() ??
                      '', // Pass the nurse/doctor user ID with fallback
              nurseLocation: nurseLocation, // Pass nurse location
              onCompleted: () async {
                await _afterEditPatient(context, accountBloc, orderNurse,
                    pop: true);
                // Go back to the previous screen (bookings list)
                if (context.mounted) Navigator.of(context).pop();
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
