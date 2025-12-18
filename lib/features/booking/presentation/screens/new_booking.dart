import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/authentication/presentation/widgets/gender_row.dart';
import 'package:icare/features/booking/presentation/widgets/new_booking_widgets/accommodation_duration_widget.dart';
import 'package:icare/features/booking/presentation/widgets/new_booking_widgets/booking_date.dart';
import 'package:icare/features/booking/presentation/widgets/new_booking_widgets/case_description.dart';
import 'package:icare/features/booking/presentation/widgets/new_booking_widgets/nurse_speciality_drop_down.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/profile_action_icons.dart';
import 'package:icare/features/booking/presentation/widgets/new_booking_widgets/patient_document.dart';
import 'package:icare/features/booking/presentation/widgets/new_booking_widgets/rapid_visit_service_drob_down.dart';
import 'package:icare/features/booking/presentation/widgets/new_booking_widgets/send_new_booking_request_button.dart';
import 'package:icare/features/booking/presentation/widgets/new_booking_widgets/welcom_section.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:flutter/material.dart';

class NewBookingScreen extends StatelessWidget {
  const NewBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DMUtil.getPC2(),
      appBar: GlobalAppBar(
          backGroundColor: DMUtil.getPC2(),
          title: "",
          // leadingIcon: DrawerIcon(ctx: context,color: DMUtil.getWC(),),
          leadingIcon: BackArrowButton(
            color: DMUtil.getWC(),
          ),
          icon: const ProfileAppBarIcons()),
      body: Container(
        alignment: Alignment.center,
        padding: AppStyle.globalPadding,
        decoration: AppStyle.globalDecoration,
        child: const SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              BookingWelcomeSection(),
              NurseSpecialityDropDown(),
              RapidVisitServicesDropDown(),
              SizedBox(
                height: 5,
              ),
              AccommodationDurationWidget(),
              GenderRow(),
              BookingDateField(),
              PatientDocument(),
              PatientDocument(),
              CaseDescription(),
              SizedBox(
                height: 10,
              ),
              SendNewBookingRequestBtn(),
            ],
          ),
        ),
      ),
    );
  }
}
