import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/data/data_sources/account_data_source.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/dot_with_title.dart';
import 'package:icare/features/authentication/data/models/user_service_model.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

/// Widget to display patient allergies for nurses
class PatientAllergiesSection extends StatefulWidget {
  final String patientId;

  const PatientAllergiesSection({
    super.key,
    required this.patientId,
  });

  @override
  State<PatientAllergiesSection> createState() =>
      _PatientAllergiesSectionState();
}

class _PatientAllergiesSectionState extends State<PatientAllergiesSection>
    with AutomaticKeepAliveClientMixin {
  late Future<UserServiceModel> _patientDataFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Cache the Future to prevent multiple API calls
    _patientDataFuture =
        UserServiceRemoteDataSource.getUserFullData(widget.patientId);
    // Fetching patient allergies

  }

  @override
  void didUpdateWidget(PatientAllergiesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only re-fetch if patientId changed
    if (oldWidget.patientId != widget.patientId) {
      setState(() {
        _patientDataFuture =
            UserServiceRemoteDataSource.getUserFullData(widget.patientId);
        // Patient ID changed, re-fetching allergies

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return FutureBuilder<UserServiceModel>(
      future: _patientDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.allergiesList == null ||
            snapshot.data!.allergiesList!.isEmpty) {
          return const SizedBox.shrink();
        }

        final allergies = snapshot.data!.allergiesList!;

        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                  final allergy = allergies[index];
                  return DotWithTitleView(
                    title: allergy.value,
                    titleWidth: 60,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
