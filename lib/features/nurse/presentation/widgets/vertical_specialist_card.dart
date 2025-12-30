import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/strings/enum/payment_enum.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/location/location_util.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/screens/main_order_screen.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/locations/presentation/screens/set_and_get_coordinates.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_event.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/nurse/presentation/screens/nurse_details_screen.dart';
import 'package:icare/features/search/presentation/bloc/search_bloc.dart';
import 'package:icare/features/search/presentation/bloc/search_state.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/global_app_image.dart';
import 'package:icare/features/shared_widgets/review.dart';
import 'package:icare/features/shared_widgets/selected_services_display.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';

class VerticalSpecialistCard extends StatelessWidget {
  final NurseEntity nurse;
  const VerticalSpecialistCard({
    super.key,
    required this.nurse,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Always navigate to nurse details when tapping the card
        NurseBloc.get(context).add(UpdateCurrentNurseEvent(nurse: nurse));
        Util.pushPage(const NurseDetails(), context);
      },
      child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      ImageWidget(
                        imgUrl: nurse.userData!.image.toString(),
                        width: 60,
                        height: 60,
                        fit: BoxFit.fill,
                        errorImg: AppImages.nurse,
                        radius: 50,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: BlocBuilder<SearchBloc, SearchState>(
                          builder: (context, state) {
                            final searchBloc = SearchBloc.get(context);
                            final hasSelectedServices =
                                searchBloc.selectedServices.isNotEmpty;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: nurse.viewTypeText(),
                                  color: DMUtil.getText(),
                                  fontSize: AppStyle.small.sp - 1,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomText(
                                  text: nurse.userData!.userName.toString(),
                                  color: DMUtil.getText(),
                                  fontSize: AppStyle.average.sp - 2,
                                  isEllipsis: true,
                                  maxLine: 1,
                                ),
                                // Show selected services from search if any
                                if (hasSelectedServices)
                                  SelectedServicesDisplay(
                                    selectedServices:
                                        searchBloc.selectedServices,
                                    nurse: nurse,
                                  ),
                                ReviewsWidget(
                                    amount: 200,
                                    color: DMUtil.getBookButtonColor()),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                BlocListener<BookingBloc, BookingState>(
                  listenWhen: (context, state) =>
                      state is AssignOrderSuccessfullyState ||
                      state is OrderErrorState,
                  listener: (context, state) {
                    if (state is AssignOrderSuccessfullyState) {
                      Util.pushPage(const MainBookingScreen(), context);
                    } else if (state is OrderErrorState) {
                      SnackBarBuilder.showFeedBackMessage(
                          context, state.errors, DMUtil.getRED());
                    }
                  },
                  child: BlocBuilder<BookingBloc, BookingState>(
                    builder: (context, bookingState) {
                      final bookingBloc = BookingBloc.get(context);
                      final isLoading =
                          bookingState is SendNewBookingRequestLoadingState;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomText(
                            text: LocationUtil.getDistanceView(
                                nurse.distanceKM, nurse.distanceM),
                            color: DMUtil.getText(),
                            fontSize: AppStyle.small.sp - 1,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          BlocBuilder<SearchBloc, SearchState>(
                            builder: (context, state) {
                              final searchBloc = SearchBloc.get(context);
                              final hasSelectedServices =
                                  searchBloc.selectedServices.isNotEmpty;

                              // Show loading indicator during booking request
                              if (isLoading) {
                                return SizedBox(
                                  height: 24.h,
                                  width: 74.w,
                                  child: Center(
                                    child: SizedBox(
                                      height: 16.h,
                                      width: 16.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          DMUtil.getBookButtonColor(),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return CustomButton(
                                height: 24.h,
                                width: 74.w,
                                circular: 8,
                                sideColor: hasSelectedServices
                                    ? DMUtil.getBookButtonColor()
                                    : DMUtil.getD2C(),
                                sideWidth: 1,
                                widget: CustomText(
                                  text: hasSelectedServices
                                      ? translate("booking.book")
                                      : translate("icare.select_service_first"),
                                  fontSize: AppStyle.small.sp - 1,
                                  color: hasSelectedServices
                                      ? DMUtil.getBookButtonColor()
                                      : DMUtil.getD2C(),
                                  alignCenter: true,
                                ),
                                color: DMUtil.getWC(),
                                onPressed: () async {
                                  // ✅ Validation 1: Check if user is logged in
                                  if (!Util.checkUser()) {
                                    return SnackBarBuilder.showFeedBackMessage(
                                        context,
                                        translate("toast.login"),
                                        DMUtil.getRED());
                                  }

                                  // ✅ Validation 2: Check if services are selected
                                  if (!hasSelectedServices) {
                                    return SnackBarBuilder.showFeedBackMessage(
                                        context,
                                        translate("icare.select_service_first"),
                                        DMUtil.getPC());
                                  }

                                  // ✅ Validation 3: Refresh ongoing bookings first
                                  debugPrint(
                                      "🔄 Refreshing ongoing bookings before validation...");
                                  bookingBloc
                                      .add(const GetOngoingBookingsEvent());

                                  // Wait a bit for state to update
                                  await Future.delayed(
                                      const Duration(milliseconds: 300));

                                  // Check for ongoing bookings after refresh
                                  if (bookingBloc.hasOngoingBooking()) {
                                    final ongoingBooking =
                                        bookingBloc.getOngoingBookingDetails();
                                    final nurseName = ongoingBooking?.nurseName;

                                    // Use generic message if nurse name is empty or null
                                    if (nurseName == null ||
                                        nurseName.trim().isEmpty) {
                                      debugPrint(
                                          "❌ User has ${bookingBloc.ongoingBookingsList.length} ongoing booking(s) but nurse name is missing");
                                      return SnackBarBuilder.showFeedBackMessage(
                                          context,
                                          translate(
                                              "icare.ongoing_booking_exists_generic"),
                                          DMUtil.getRED());
                                    }

                                    debugPrint(
                                        "❌ User has ongoing booking with: $nurseName");
                                    return SnackBarBuilder.showFeedBackMessage(
                                        context,
                                        translate(
                                            "icare.ongoing_booking_exists",
                                            args: {"nurseName": nurseName}),
                                        DMUtil.getRED());
                                  }

                                  debugPrint(
                                      "✅ No ongoing bookings, proceeding with booking...");

                                  // Match selected services with nurse's prices
                                  final accountBloc = AccountBloc.get(context);

                                  debugPrint(
                                      "🎯 ========== BOOK BUTTON PRESSED ==========");
                                  debugPrint("📋 Services from SearchBloc:");
                                  for (var s in searchBloc.selectedServices) {
                                    debugPrint(
                                        "   - ID: ${s.id}, Name: ${s.name}, Value: ${s.value}");
                                  }

                                  // Clear existing services
                                  debugPrint(
                                      "🗑️ Clearing orderServiceList (current count: ${bookingBloc.orderServiceList.length})");
                                  bookingBloc.orderServiceList.clear();

                                  debugPrint(
                                      "🔍 Matching ${searchBloc.selectedServices.length} services with nurse's prices...");

                                  // Match each selected service with nurse's price
                                  for (var selectedService
                                      in searchBloc.selectedServices) {
                                    debugPrint(
                                        "   📋 Processing service ID: ${selectedService.id}");
                                    debugPrint(
                                        "      - Selected service name: ${selectedService.name}");
                                    debugPrint(
                                        "      - Selected service value: ${selectedService.value}");

                                    // Find this service in nurse's service list to get the price
                                    final nurseService =
                                        nurse.servicesList?.firstWhere(
                                      (s) => s.id == selectedService.id,
                                      orElse: () => const ServicesModel(
                                          id: -1, value: ''),
                                    );

                                    if (nurseService != null &&
                                        nurseService.id != -1) {
                                      // Get service name from allServicesList
                                      final serviceFromList =
                                          accountBloc.allServiceList.firstWhere(
                                        (s) => s.id == selectedService.id,
                                        orElse: () => const ServicesModel(
                                            id: -1, value: ''),
                                      );

                                      // ✅ FIX: Use 'value' field as service name (API stores names in 'value')
                                      String serviceName;
                                      if (serviceFromList.id != -1) {
                                        // Found in allServiceList - use its value as name
                                        serviceName =
                                            serviceFromList.name?.isNotEmpty ==
                                                    true
                                                ? serviceFromList.name!
                                                : serviceFromList.value;
                                      } else {
                                        // Not in allServiceList - use selectedService's value as name
                                        serviceName =
                                            selectedService.name?.isNotEmpty ==
                                                    true
                                                ? selectedService.name!
                                                : selectedService.value;
                                      }

                                      debugPrint(
                                          "✅ Matched service: $serviceName (${nurseService.value} LE)");
                                      debugPrint(
                                          "   - Service ID: ${selectedService.id}");
                                      debugPrint(
                                          "   - Service Name (final): $serviceName");
                                      debugPrint(
                                          "   - Nurse's Price: ${nurseService.value}");

                                      // Add service with nurse's price and correct name
                                      bookingBloc.orderServiceList.add(
                                        ServicesModel(
                                          id: selectedService.id,
                                          value: nurseService
                                              .value, // Use nurse's price
                                          name:
                                              serviceName, // Use correct service name
                                        ),
                                      );

                                      debugPrint(
                                          "   ➕ Added to orderServiceList");
                                    } else {
                                      debugPrint(
                                          "⚠️ Service ${selectedService.id} not offered by this nurse");
                                    }
                                  }

                                  debugPrint(
                                      "📦 Ready to book with ${bookingBloc.orderServiceList.length} services");
                                  debugPrint("📋 Final orderServiceList:");
                                  for (var s in bookingBloc.orderServiceList) {
                                    debugPrint(
                                        "   ✓ ID: ${s.id}, Name: ${s.name}, Price: ${s.value}");
                                  }
                                  debugPrint(
                                      "🎯 ==========================================");

                                  // ✅ Validation 4: Check if any services were matched
                                  if (bookingBloc.orderServiceList.isEmpty) {
                                    return SnackBarBuilder.showFeedBackMessage(
                                        context,
                                        translate(
                                            "icare.nurse_does_not_offer_service"),
                                        DMUtil.getRED());
                                  }

                                  debugPrint(
                                      "📦 Ready to book with ${bookingBloc.orderServiceList.length} services");

                                  // Navigate to map for location selection
                                  final res = await Util.pushPage(
                                      MapScreen(
                                          isSet: true,
                                          title: translate(
                                              'profile.confirm_current_location')),
                                      context);

                                  // If location selected, create the booking
                                  if (res != null && res is LocationMapEntity) {
                                    bookingBloc.add(AddOrderEvent(
                                        context: context,
                                        payment: const PaymentOption(
                                            paymentEnum: PaymentEnum.CASH),
                                        orderData: {
                                          'nurse_id': nurse.id,
                                          'lat': res.lat.toString(),
                                          'long': res.long.toString(),
                                          'address': res.address.toString(),
                                        }));
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          )),
    );
  }
}
