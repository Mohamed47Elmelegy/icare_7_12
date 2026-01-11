import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/setting/domain/entities/specialty_entity.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/doctor/domain/entities/doctor_entity.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

/// Widget to display the doctor's specialty as a selected service
class DoctorSelectedSpecialtyDisplay extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorSelectedSpecialtyDisplay({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    if (doctor.specialtyId == null) {
      return const SizedBox.shrink();
    }

    // Get specialty name from AccountBloc
    var accountBloc = AccountBloc.get(context);
    String specialtyName = "";

    try {
      var specialty = accountBloc.allSpecialtiesList.firstWhere(
        (element) => element.id.toString() == doctor.specialtyId,
        orElse: () => accountBloc.allSpecialtiesList.firstWhere(
          (element) => element.id == int.tryParse(doctor.specialtyId ?? "0"),
          orElse: () => const SpecialtyEntity(id: 0, title: ""),
        ),
      );
      if (specialty.id != 0) {
        specialtyName = specialty.title;
      }
    } catch (e) {
      // If not found in list, fallback or keep empty
    }

    if (specialtyName.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6.h),
        Padding(
          padding: EdgeInsets.only(bottom: 3.h),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 12.w,
                color: DMUtil.getPC(),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: CustomText(
                  text: specialtyName,
                  fontSize: AppStyle.small.sp - 2,
                  color: DMUtil.getDC(),
                  maxLine: 1,
                  isEllipsis: true,
                ),
              ),
              /* 
              // Doctors don't have a fixed price list visible here usually, 
              // but if we want to show a price, we need a source for it. 
              // For now, we just show the specialty name as the "service".
              SizedBox(width: 4.w),
              CustomText(
                text: "0 ${translate("icare.le")}", 
                fontSize: AppStyle.small.sp - 2,
                fontWeight: FontWeight.w600,
                color: DMUtil.getPC(),
              ),
              */
            ],
          ),
        ),
      ],
    );
  }
}
