import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_event.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';
import 'package:icare/features/authentication/presentation/widgets/gender_row.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class NurseType extends StatelessWidget {
  final Color? txtColor;
  final Color? selectedColor;
  const NurseType({super.key,this.txtColor,this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc,AuthState>(
      builder: (ctx,state){
        var bloc = AuthBloc.get(ctx);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: ()=> bloc.add(const SwitchNurseTypeEvent(isNurse: true)),
              child: Row(
                children: [
                  SelectedCircle(selected: bloc.isNurse,selectedColor: selectedColor,),
                  const SizedBox(width: 10,),
                  CustomText(
                    text: translate("nurse.nurse"),
                    fontSize: AppStyle.small.sp,
                  ),
                ],
              ),
            ),

            InkWell(
              onTap: ()=> bloc.add(const SwitchNurseTypeEvent(isNurse: false)),
              child: Row(
                children: [
                  SelectedCircle(selected: !bloc.isNurse,selectedColor: selectedColor,),
                  const SizedBox(width: 10,),
                  CustomText(
                    text: translate("nurse.assistant"),
                    fontSize: AppStyle.small.sp,
                  ),
                ],
              ),
            ),

          ],
        );
      },
    );
  }
}