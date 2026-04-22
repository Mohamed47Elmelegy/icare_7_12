// ignore_for_file: use_build_context_synchronously
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/booking/data/models/order_model.dart';
import 'package:icare/core/strings/enum/order_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/booking/presentation/screens/booking_details.dart';
import 'package:icare/features/booking/presentation/widgets/booking_row_actions.dart';
import 'package:icare/features/booking/presentation/widgets/order_tracking_widgets/info_row_widget.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/doctor/presentation/bloc/doctors_bloc.dart';
import 'package:icare/features/search/domain/entities/searchable_entity.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/account/data/data_sources/account_data_source.dart';
import 'package:icare/features/locations/presentation/screens/set_and_get_coordinates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/booking_nurse/booking_nurse_cubit.dart';
import 'package:icare/features/booking/presentation/bloc/booking_nurse/booking_nurse_state.dart';
import 'package:icare/injection_container_import.dart' as di;
import 'package:icare/features/booking/domain/use_cases/get_patient_details_usecase.dart';
import 'package:icare/features/authentication/data/models/user_service_model.dart';

class OrderCardDetails extends StatelessWidget {
  final bool enableTracking;
  final Booking item;
  final bool isTrack;
  const OrderCardDetails({
    super.key,
    this.enableTracking = false,
    required this.item,
    this.isTrack = false,
  });

  @override
  Widget build(BuildContext context) {
    // Try to find nurse first
    var nurseList = NurseBloc.get(context).nursesList;
    int nurseIndex =
        nurseList.indexWhere((element) => item.nurseID == element.id);

    // If not found in nurses, try doctors
    SearchableEntity? orderProvider;
    if (nurseIndex != -1) {
      orderProvider = nurseList[nurseIndex];
    } else {
      var doctorList = DoctorBloc.get(context).doctorsList;
      int doctorIndex =
          doctorList.indexWhere((element) => item.nurseID == element.id);
      if (doctorIndex != -1) {
        orderProvider = doctorList[doctorIndex];
      }
    }

    if (orderProvider == null || item.userId == null) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () => Util.pushPage(BookingDetailsScreen(item: item), context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: DMUtil.getWC(),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: BlocProvider(
          create: (context) {
            final cubit = BookingNurseCubit(
              getPatientDetailsUseCase: di.sl<GetPatientDetailsUseCase>(),
            );
            // Only fetch patient details if the current user is a Nurse
            if (!Util.isCustomer()) {
              cubit.getPatientDetails(item.userId.toString());
            }
            return cubit;
          },
          child: BlocBuilder<BookingNurseCubit, BookingNurseState>(
            builder: (context, state) {
              String userImage = "";
              if (Util.isCustomer()) {
                // If Customer, show Provider (Nurse/Doctor) Image
                userImage = orderProvider?.userData?.image ?? "";
              } else {
                // If Nurse/Doctor, show Patient Image (from API/Cubit or item)
                UserServiceModel? patientData;
                if (state is BookingNurseLoaded) {
                  patientData = state.patientData;
                }
                userImage = (patientData?.image != null &&
                        patientData!.image!.isNotEmpty)
                    ? patientData.image!
                    : (item.userImage ?? "");
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Patient Image
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: DMUtil.getPC().withValues(alpha: 0.1),
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

                      // Info Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Info Grid (2 columns)
                            Row(
                              children: [
                                Expanded(
                                  child: InfoRowWidget(
                                    label: Util.isCustomer()
                                        ? translate("order.nurse")
                                        : translate("order.customer"),
                                    value: Util.isCustomer()
                                        ? "${item.nurseName}"
                                        : "${item.userName}",
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: InfoRowWidget(
                                    label: translate("order.requested_service"),
                                    value: item.desc ?? "",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),

                            Row(
                              children: [
                                Expanded(
                                  child: InfoRowWidget(
                                    label: translate("order.gender"),
                                    value: (orderProvider?.userData?.isWomen ==
                                            true
                                        ? translate("profile.female")
                                        : translate("profile.male")),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: InfoRowWidget(
                                    label: translate("order.destination"),
                                    value: "Far By",
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomText(
                                          text:
                                              "${orderProvider?.distanceKM?.toStringAsFixed(1) ?? '0'} Km",
                                          color: DMUtil.getD2C(),
                                          fontSize: AppStyle.verySmall.sp,
                                        ),
                                        SizedBox(width: 8.w),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // On Map button - only show for non-completed bookings
                            if (item.status != null &&
                                OrderModel.getStatusViewCheck(item.status!) !=
                                    ORDER_STATUS.COMPLETED)
                              InkWell(
                                onTap: () async {
                                  try {
                                    final trackingProvider =
                                        await UserServiceRemoteDataSource
                                            .getUserFullData((orderProvider!
                                                        .userData!.userId ??
                                                    0)
                                                .toString());
                                    Util.pushPage(
                                      MapScreen(
                                        isSet: true,
                                        title: trackingProvider.userName
                                            .toString(),
                                        latitude:
                                            trackingProvider.lat.toString(),
                                        longitude:
                                            trackingProvider.long.toString(),
                                        userID:
                                            trackingProvider.userId.toString(),
                                        userImg: trackingProvider.image,
                                      ),
                                      context,
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text(translate("toast.oops"))),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: DMUtil.getD2C()
                                            .withValues(alpha: 0.3)),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: CustomText(
                                    text: translate("order.on_map"),
                                    fontSize: AppStyle.verySmall.sp - 1,
                                    color:
                                        DMUtil.getD2C().withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Actions
                  BookingRowActions(item: item, orderNurse: orderProvider!),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
