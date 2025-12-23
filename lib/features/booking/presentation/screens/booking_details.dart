import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/booking/presentation/views/booking_patient_view.dart';
import 'package:icare/features/booking/presentation/views/booking_nurse_view.dart';

import '../../../../core/styles/app_style.dart';
import '../../../../core/utils/dark_mode_utility.dart';
import '../../../../core/utils/small_fun.dart';
import '../../../../injection_container_import.dart' as di;
import '../../../shared_widgets/custom_text.dart';
import '../../../shared_widgets/global_widgets.dart';
import '../../domain/entities/order.dart';
import '../bloc/booking_nurse/booking_nurse_cubit.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Booking item;
  final bool showActions;

  const BookingDetailsScreen({
    super.key,
    required this.item,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPatient = Util.isCustomer();

    return Scaffold(
      backgroundColor: DMUtil.getWC(),
      appBar: AppBar(
        backgroundColor: DMUtil.getWC(),
        elevation: 0,
        leading: BackArrowButton(color: DMUtil.getDC()),
        centerTitle: true,
        title: CustomText(
          text:
              translate("booking.booking_details") != "booking.booking_details"
                  ? translate("booking.booking_details")
                  : "Booking Details",
          fontSize: AppStyle.large.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Only allow refresh for nurses viewing patient details
          if (!isPatient) {
            final cubit = di.sl<BookingNurseCubit>();
            await cubit.getPatientDetails(
              item.userId.toString(),
              forceRefresh: true,
            );
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: isPatient
              ? BookingPatientView(item: item)
              : BookingNurseView(item: item),
        ),
      ),
    );
  }
}
