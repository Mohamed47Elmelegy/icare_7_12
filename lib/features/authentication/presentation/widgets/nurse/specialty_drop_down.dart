import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_event.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';
import 'package:icare/features/setting/data/models/specialty_model.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class SpecialtyListDropDown extends StatelessWidget {
  const SpecialtyListDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (ctx, state) {
        var bloc = AuthBloc.get(ctx);
        var list = bloc.specialtyList;

        if (list == null || list.isEmpty) {
          if (bloc.isDoctor && list == null) {
            return const CircularProgressIndicator();
          }
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: DMUtil.getWC(),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: DMUtil.getOpacity())),
          child: DropdownButton<SpecialtyModel>(
            value: bloc.selectedSpecialty,
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
            onChanged: (SpecialtyModel? newValue) {
              if (newValue != null) {
                bloc.add(UpdateSpecialtyEvent(
                    specialtyId: newValue.id, specialty: newValue));
              }
            },
            items: list
                .map<DropdownMenuItem<SpecialtyModel>>((SpecialtyModel value) {
              return DropdownMenuItem<SpecialtyModel>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomText(
                    text: value.title.toString(),
                    fontSize: AppStyle.small.sp,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
