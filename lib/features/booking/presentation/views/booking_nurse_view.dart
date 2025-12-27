import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/dot_with_title.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/presentation/widgets/booking_info_column.dart';
import 'package:icare/features/booking/presentation/widgets/booking_info_row.dart';
import 'package:icare/features/booking/presentation/widgets/booking_row_actions.dart';
import 'package:icare/features/booking/presentation/widgets/real_time_distance_tracker.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/authentication/data/models/user_service_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/booking_nurse/booking_nurse_cubit.dart';
import 'package:icare/features/booking/presentation/bloc/booking_nurse/booking_nurse_state.dart';
import 'package:icare/injection_container_import.dart' as di;

/// Nurse view for booking details - shows patient information
class BookingNurseView extends StatelessWidget {
  final Booking item;

  const BookingNurseView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // ⚠️ مؤقت – للحصول على orderNurse للـ actions
    final list = NurseBloc.get(context).nursesList;
    final index = list.indexWhere((e) => item.nurseID == e.id);
    final orderNurse = index != -1 ? list[index] : null;

    // Use singleton cubit to preserve cache
    return BlocProvider.value(
      value: di.sl<BookingNurseCubit>()
        ..getPatientDetails(item.userId.toString()),
      child: BlocBuilder<BookingNurseCubit, BookingNurseState>(
        builder: (context, state) {
          UserServiceModel? patientData;
          if (state is BookingNurseLoaded) {
            patientData = state.patientData;
          }

          return Column(
            children: [
              _PatientInfoCard(
                item: item,
                patientData: patientData,
              ),
              // Display patient allergies from User Data API
              const _PatientAllergiesSection(),

              if (orderNurse != null)
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: BookingRowActions(
                    item: item,
                    orderNurse: orderNurse,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Widget to fetch and display patient allergies from API
class _PatientAllergiesSection extends StatelessWidget {
  const _PatientAllergiesSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingNurseCubit, BookingNurseState>(
      builder: (context, state) {
        if (state is BookingNurseLoading) {
          // Optional: Show loading indicator or simple sizedbox
          return const SizedBox.shrink();
        } else if (state is BookingNurseLoaded) {
          final allergies = state.patientData.allergiesList;

          if (allergies == null || allergies.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: DMUtil.getWC(),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: translate("profile.allergies"),
                  fontSize: AppStyle.average.sp,
                  fontWeight: FontWeight.w600,
                  color: DMUtil.getDC(),
                ),
                SizedBox(height: 12.h),
                GridView.builder(
                  itemCount: allergies.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 7.w,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return DotWithTitleView(
                      title: allergies[index].value,
                      titleWidth: 60,
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

/// Private widget for patient information card
class _PatientInfoCard extends StatelessWidget {
  final Booking item;
  final UserServiceModel? patientData;

  const _PatientInfoCard({
    required this.item,
    this.patientData,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the values to display, prioritizing patientData (from API) over item (from Booking list)
    final String userImage =
        (patientData?.image != null && patientData!.image!.isNotEmpty)
            ? patientData!.image!
            : (item.userImage ?? "");

    final String phoneNumber = (patientData?.phoneNumber != null &&
            patientData!.phoneNumber!.isNotEmpty)
        ? patientData!.phoneNumber!
        : (item.mobile ?? "");

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: DMUtil.getWC(),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with image and name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: DMUtil.getPC().withOpacity(0.1),
                  image: userImage.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(userImage),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: userImage.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 30.w,
                        color: DMUtil.getPC(),
                      )
                    : null,
              ),
              SizedBox(width: 12.w),
              // Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: item.userName ?? "",
                      fontSize: AppStyle.average.sp,
                      fontWeight: FontWeight.w600,
                      color: DMUtil.getDC(),
                      maxLine: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Info rows
          BookingInfoRow(
            label1: translate("profile.gender"),
            value1: item.userGender == 'male'
                ? translate("profile.male")
                : translate("profile.female"),
            label2: translate("order.requested_service"),
            value2: item.desc ?? "",
          ),
          SizedBox(height: 12.h),

          // Phone number
          if (phoneNumber.isNotEmpty)
            Column(
              children: [
                BookingInfoColumn(
                  label: translate("profile.mobile"),
                  value: phoneNumber,
                  isFullWidth: true,
                ),
                SizedBox(height: 12.h),
              ],
            ),

          // Address
          if (item.shippingAddress != null && item.shippingAddress!.isNotEmpty)
            Column(
              children: [
                BookingInfoColumn(
                  label: translate("profile.address"),
                  value: item.shippingAddress!,
                  isFullWidth: true,
                ),
                SizedBox(height: 12.h),
              ],
            ),

          // Distance row - Real-time tracking
          if (item.lat != null &&
              item.lat != 0 &&
              item.lng != null &&
              item.lng != 0)
            Column(
              children: [
                RealTimeDistanceTracker(
                  patientLat: item.lat!,
                  patientLng: item.lng!,
                  bookingStatus: item.status,
                  enableAutoUpdate: true,
                ),
                SizedBox(height: 12.h),
              ],
            ),

          // Patient Location button
          InkWell(
            onTap: () => Util.openMapApp(
              item.lat.toString(),
              item.lng.toString(),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: DMUtil.getD2C().withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16.w,
                    color: DMUtil.getPC(),
                  ),
                  SizedBox(width: 6.w),
                  CustomText(
                    text: translate("order.patient_location"),
                    fontSize: AppStyle.small.sp,
                    color: DMUtil.getPC(),
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
