import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_event.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class PatientKindListDropDown extends StatelessWidget {
  const PatientKindListDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: DMUtil.getWC(),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1,color:  DMUtil.getOpacity())
      ),
      child: BlocBuilder<AuthBloc,AuthState>(
        builder: (ctx,state){
          var bloc = AuthBloc.get(ctx);
          return DropdownButton<String>(
            value: null,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 10,
            menuMaxHeight: 250.h,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomText(
                text: bloc.customerType ?? translate("signup.iam"),
                fontSize: AppStyle.small.sp,
                color: DMUtil.getD2C(),
              ),
            ),
            isExpanded: true,
            style: TextStyle(color: DMUtil.getD2C()),
            underline: const SizedBox(),
            onChanged: (String? newValue) => bloc.add(UpdateCustomerTypeEvent(type: newValue.toString())),
            items: <String>[
              translate("icare.relative_patient"),
              translate("icare.patient"),
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: CustomText(
                  text: value.toString(),
                  fontSize: AppStyle.small.sp,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}