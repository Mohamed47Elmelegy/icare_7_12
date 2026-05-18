import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/services_bloc.dart';
import 'package:icare/features/account/presentation/bloc/services_state.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/authentication/presentation/cubit/registration_cubit.dart';
import 'package:icare/features/setting/domain/entities/specialty_entity.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

import '../../../../account/presentation/bloc/services_event.dart';

class SpecialtyListDropDown extends StatelessWidget {
  const SpecialtyListDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesBloc, ServicesState>(
      builder: (ctx, servicesState) {
        var servicesBloc = ServicesBloc.get(ctx);
        var specialties = servicesBloc.allSpecialtiesList;

        // Data source: ServicesBloc (correct — unchanged)
        // Selected value: RegistrationCubit (fixed — was AuthBloc)
        return BlocBuilder<RegistrationCubit, RegistrationState>(
          builder: (ctx, regState) {
            var authBloc = AuthBloc.get(ctx);

            if (specialties.isEmpty) {
              if (authBloc.isDoctor && servicesState is ServicesLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (authBloc.isDoctor &&
                  specialties.isEmpty &&
                  servicesState is! ServicesLoading) {
                servicesBloc
                    .add(const FetchAllServicesEvent(userType: 'doctor'));
              }
              return const SizedBox.shrink();
            }

            // Find currently selected entity from the list
            SpecialtyEntity? selectedEntity;
            if (regState.selectedSpecialtyId != null) {
              try {
                selectedEntity = specialties.firstWhere(
                  (element) => element.id == regState.selectedSpecialtyId,
                );
              } catch (_) {
                selectedEntity = null;
              }
            }

            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: DMUtil.getWC(),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: DMUtil.getOpacity())),
              child: DropdownButton<SpecialtyEntity>(
                value: selectedEntity,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 10,
                menuMaxHeight: 250.h,
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomText(
                    text: translate("signup.specialization"),
                    fontSize: AppStyle.small.sp,
                    color: DMUtil.getD2C(),
                  ),
                ),
                isExpanded: true,
                style: TextStyle(color: DMUtil.getD2C()),
                underline: const SizedBox(),
                onChanged: (SpecialtyEntity? newValue) {
                  if (newValue != null) {
                    // Write to RegistrationCubit only (fixed)
                    RegistrationCubit.get(ctx).selectSpecialty(
                      id: newValue.id,
                      entity: newValue,
                    );
                  }
                },
                items: specialties.map<DropdownMenuItem<SpecialtyEntity>>(
                    (SpecialtyEntity value) {
                  return DropdownMenuItem<SpecialtyEntity>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomText(
                        text: value.title,
                        fontSize: AppStyle.small.sp,
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}
