import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/setting/domain/entities/specialty_entity.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

/// Doctor-specific dropdown for specialty selection (single selection)
class SpecialtyListDropDown extends StatelessWidget {
  final double width;
  const SpecialtyListDropDown({super.key, this.width = 110});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, state) {
        var bloc = AccountBloc.get(ctx);
        List<SpecialtyEntity> specialtiesList = bloc.allSpecialtiesList;

        if (specialtiesList.isEmpty) return const SizedBox.shrink();

        SpecialtyEntity? currentSpecialty = bloc.selectedSpecialty;

        return Container(
          width: width.w,
          decoration: BoxDecoration(
            color: DMUtil.getWC(),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: DMUtil.getOpacity()),
          ),
          child: DropdownButton<SpecialtyEntity>(
            value: null,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 10,
            menuMaxHeight: 250.h,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomText(
                text: currentSpecialty == null
                    ? translate("doctor.select_specialty")
                    : currentSpecialty.title,
                fontSize: AppStyle.small.sp,
                color: DMUtil.getD2C(),
              ),
            ),
            isExpanded: true,
            style: TextStyle(color: DMUtil.getD2C()),
            underline: const SizedBox(),
            onChanged: (SpecialtyEntity? newValue) {
              if (newValue != null) {
                // Convert specialty to service model for compatibility
                ServicesModel serviceModel = ServicesModel(
                  id: newValue.id,
                  value: newValue.title,
                  name: newValue.title,
                  userType: 'doctor',
                );

                bloc.add(ChangeCurrentService(
                  item: serviceModel,
                  txt: serviceModel.value.toString(),
                ));
              }
            },
            items: specialtiesList.map<DropdownMenuItem<SpecialtyEntity>>(
                (SpecialtyEntity specialty) {
              return DropdownMenuItem<SpecialtyEntity>(
                value: specialty,
                child: CustomText(
                  text: specialty.title,
                  fontSize: AppStyle.small.sp,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
