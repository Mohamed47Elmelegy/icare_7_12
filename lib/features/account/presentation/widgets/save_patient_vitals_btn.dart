import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/app_logger.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/today_monitoring_vitals.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';

class SavePatientVitalsAndCompleteBookingBtn extends StatefulWidget {
  final Booking booking;
  final GlobalKey<TodayMonitoringVitalsState> vitalsKey;
  final VoidCallback? onCompleted;
  final String
      healthcareProviderId; // Original nurse/doctor ID before context switch
  final Map<String, dynamic>?
      nurseLocation; // Nurse's GPS location for geofencing

  const SavePatientVitalsAndCompleteBookingBtn({
    super.key,
    required this.booking,
    required this.vitalsKey,
    required this.healthcareProviderId,
    this.onCompleted,
    this.nurseLocation,
  });

  @override
  State<SavePatientVitalsAndCompleteBookingBtn> createState() =>
      _SavePatientVitalsAndCompleteBookingBtnState();
}

class _SavePatientVitalsAndCompleteBookingBtnState
    extends State<SavePatientVitalsAndCompleteBookingBtn> {
  bool _isProcessing = false;
  bool _waitingForProfileUpdate = false;
  bool _waitingForMedicalReport = false;
  Map<String, String>? _pendingVitalValues;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        AppLogger.d("🔵 [COMPLETE ORDER] AccountBloc State: ${state.runtimeType}");
        AppLogger.d(
            "🔵 [COMPLETE ORDER] _waitingForProfileUpdate: $_waitingForProfileUpdate");
        AppLogger.d(
            "🔵 [COMPLETE ORDER] _waitingForMedicalReport: $_waitingForMedicalReport");

        // Handle profile update states ONLY if waiting for profile update
        if (state is UpdateProfileState && _waitingForProfileUpdate) {
          AppLogger.d(
              "🟢 [STEP 2] Profile Update State - isSuccess: ${state.response.isSuccess}, isFailed: ${state.response.isFailed}");
          if (state.response.isSuccess == true) {
            // Profile updated successfully, now create medical report
            AppLogger.d("✅ [STEP 2] Profile updated successfully!");
            _waitingForProfileUpdate = false;
            _createMedicalReport();
          } else if (state.response.isFailed == true) {
            // Profile update failed
            AppLogger.e("❌ [STEP 2] Profile update FAILED: ${state.response.msg}");
            _waitingForProfileUpdate = false;
            setState(() => _isProcessing = false);
            SnackBarBuilder.showFeedBackMessage(
              context,
              state.response.msg ?? translate("toast.oops"),
              DMUtil.getRED(),
            );
          }
        } else if (state is MedicalReportCreatedState) {
          AppLogger.d("🟡 [DEBUG STEP 3] Received MedicalReportCreatedState");
          AppLogger.d(
              "🟡 [DEBUG STEP 3] _waitingForMedicalReport = $_waitingForMedicalReport");
          if (!_waitingForMedicalReport) {
            AppLogger.w(
                "❌ [DEBUG STEP 3] SKIPPED! _waitingForMedicalReport is FALSE");
            return;
          }
          // Medical report created successfully, now update order
          AppLogger.d("✅ [STEP 3] Medical report created successfully!");
          _waitingForMedicalReport = false;
          AppLogger.d("🔄 [DEBUG STEP 3] Calling _submitOrderUpdate()...");
          _submitOrderUpdate();
          AppLogger.d("✅ [DEBUG STEP 3] _submitOrderUpdate() called!");
        } else if (state is MedicalReportErrorState) {
          if (!_waitingForMedicalReport) return;
          // Medical report creation failed
          AppLogger.e("❌ [STEP 3] Medical report creation FAILED: ${state.error}");
          _waitingForMedicalReport = false;
          setState(() => _isProcessing = false);
          SnackBarBuilder.showFeedBackMessage(
            context,
            state.error,
            DMUtil.getRED(),
          );
        }
      },
      child: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          AppLogger.d("🔵 [COMPLETE ORDER] BookingBloc State: ${state.runtimeType}");
          AppLogger.d("🔵 [COMPLETE ORDER] _isProcessing: $_isProcessing");

          if (!_isProcessing) return;

          if (state is UpdateOrderSuccessfullyState) {
            // Success - show message and call completion callback
            AppLogger.d("✅ [STEP 4] Order updated to COMPLETED successfully!");
            SnackBarBuilder.showFeedBackMessage(
              context,
              translate("order.order_completed_successfully"),
              DMUtil.getGreen(),
            );

            setState(() => _isProcessing = false);

            if (widget.onCompleted != null) {
              AppLogger.d("🔄 [STEP 5] Calling onCompleted callback...");
              widget.onCompleted!();
            }
          } else if (state is OrderErrorState) {
            // Error - show error message
            AppLogger.e("❌ [STEP 4] Order update FAILED: ${state.errors}");
            SnackBarBuilder.showFeedBackMessage(
              context,
              state.errors,
              DMUtil.getRED(),
            );

            setState(() => _isProcessing = false);
          }
        },
        builder: (context, state) {
          return Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(10),
            child: CustomButton(
              height: 34.w,
              width: 250.w,
              widget: _isProcessing
                  ? SizedBox(
                      height: 20.w,
                      width: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          DMUtil.getWC(),
                        ),
                      ),
                    )
                  : CustomText(
                      text: "Save & Complete",
                      fontSize: AppStyle.small.sp,
                      fontWeight: FontWeight.w600,
                      color: DMUtil.getWC(),
                    ),
              color: DMUtil.getPC(),
              onPressed: _isProcessing ? null : _handleSaveAndComplete,
            ),
          );
        },
      ),
    );
  }

  void _handleSaveAndComplete() async {
    AppLogger.d("\n🚀 [STEP 1] Starting Complete Order Flow...");
    AppLogger.d("📋 [STEP 1] Booking ID: ${widget.booking.orderId}");
    AppLogger.d("👤 [STEP 1] Patient ID: ${widget.booking.userId}");
    AppLogger.d("🏥 [STEP 1] Healthcare Provider ID: ${widget.healthcareProviderId}");

    final vitalsState = widget.vitalsKey.currentState;
    if (vitalsState == null) {
      AppLogger.e("❌ [STEP 1] Vitals state is NULL!");
      return;
    }

    final vitalValues = vitalsState.getVitalValues();
    AppLogger.d("💉 [STEP 1] Vital Values: $vitalValues");

    if (vitalValues.values.any((element) => element.isEmpty)) {
      AppLogger.w(
          "❌ [STEP 1] Validation FAILED - Some vitals are empty: $vitalValues");
      SnackBarBuilder.showFeedBackMessage(
        context,
        translate("toast.empty"),
        DMUtil.getRED(),
      );
      return;
    }

    AppLogger.d("✅ [STEP 1] Validation PASSED - All vitals filled");
    setState(() => _isProcessing = true);
    _pendingVitalValues = vitalValues;

    // Save patient profile updates (Medical Conditions & Publications)
    final accountBloc = AccountBloc.get(context);
    final Map<String, dynamic> profileUpdates = {};

    if (accountBloc.currentMedicalConditions.isNotEmpty) {
      profileUpdates['medical_conditions'] =
          accountBloc.currentMedicalConditions;
      AppLogger.d(
          "📝 [STEP 1] Adding medical conditions: ${accountBloc.currentMedicalConditions}");
    }

    if (accountBloc.currentPublication.isNotEmpty) {
      profileUpdates['publications'] = accountBloc.currentPublication;
      AppLogger.d(
          "📝 [STEP 1] Adding publications: ${accountBloc.currentPublication}");
    }

    // Add vitals to profile updates to satisfy backend requirement
    profileUpdates.addAll(vitalValues);
    // Set 'profile' flag to '1' to trigger the profile update section in the data source
    profileUpdates['profile'] = '1';
    // CRITICAL: Set user_id to the PATIENT'S ID so we update the patient, not the nurse
    profileUpdates['user_id'] = widget.booking.userId.toString();

    // Always trigger profile update first
    _waitingForProfileUpdate = true;
    AppLogger.d("🔄 [STEP 2] Updating profile with data: $profileUpdates");
    accountBloc.add(UpdateProfileEvent(user: profileUpdates));
  }

  void _createMedicalReport() {
    AppLogger.d("\n🔄 [STEP 3] Creating Medical Report...");
    if (_pendingVitalValues == null) {
      AppLogger.e("❌ [STEP 3] _pendingVitalValues is NULL!");
      return;
    }
    final vitalValues = _pendingVitalValues!;

    // Get description and image from the widget state
    String description = '';
    File? prescriptionImage;

    final vitalsState = widget.vitalsKey.currentState;
    if (vitalsState != null) {
      description = vitalsState.getDescription();
      prescriptionImage = vitalsState.getPrescriptionImage();
    }

    // Fallback if description is empty
    if (description.isEmpty) {
      description = 'Follow-up report - ${DateTime.now().toString()}';
    }

    final reportData = {
      'patient_id': widget.booking.userId.toString(),
      'created_by': widget.healthcareProviderId,
      'heartRate': vitalValues['heart_rate'],
      'bloodPressure': vitalValues['blood_pressure'],
      'height': vitalValues['height'],
      'weight': vitalValues['weight'],
      'pulseRate': vitalValues['pulse_rate'],
      'description': description,
    };

    AppLogger.d("📋 [STEP 3] Medical Report Data: $reportData");
    if (prescriptionImage != null) {
      AppLogger.d("📸 [STEP 3] Attaching prescription image");
    }

    _waitingForMedicalReport = true;
    AccountBloc.get(context).add(CreateMedicalReportEvent(
      data: reportData,
      prescriptionImage: prescriptionImage,
    ));
  }

  void _submitOrderUpdate() {
    AppLogger.d("\n🔄 [STEP 4] Updating Order Status to COMPLETED...");
    if (_pendingVitalValues == null) {
      AppLogger.e("❌ [STEP 4] _pendingVitalValues is NULL!");
      return;
    }
    final vitalValues = _pendingVitalValues!;

    final orderData = {
      'booking_id': widget.booking.orderId.toString(),
      'status': 'COMPLETED',
      'heart_rate': vitalValues['heart_rate'],
      'blood_pressure': vitalValues['blood_pressure'],
      'height': vitalValues['height'],
      'weight': vitalValues['weight'],
      'pulse_rate': vitalValues['pulse_rate'],
    };

    // Add nurse location for geofencing audit
    if (widget.nurseLocation != null) {
      orderData['nurse_latitude'] =
          widget.nurseLocation!['latitude'].toString();
      orderData['nurse_longitude'] =
          widget.nurseLocation!['longitude'].toString();
      orderData['distance_to_patient'] =
          widget.nurseLocation!['distance'].toString();
      AppLogger.d(
          "📍 [STEP 4] Nurse Location: Lat=${orderData['nurse_latitude']}, Lng=${orderData['nurse_longitude']}, Distance=${orderData['distance_to_patient']}m");
    }

    AppLogger.d("📋 [STEP 4] Order Update Data: $orderData");
    AppLogger.d("🎯 [STEP 4] Setting status to: COMPLETED");

    BookingBloc.get(context).add(UpdateOrderEvent(data: orderData));
  }
}
