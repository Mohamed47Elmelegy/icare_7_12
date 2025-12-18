import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class SaveProfileBtn extends StatelessWidget {
  const SaveProfileBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is UpdateNurseDataSuccessState ||
            state is UpdateDoctorDataSuccessState) {
          Timer(const Duration(seconds: 2), () {
            AccountBloc.get(context).add(const FetchProfileDataEvent());
          });
        }
      },
      listenWhen: (previous, current) =>
          current is UpdateNurseDataSuccessState ||
          current is UpdateDoctorDataSuccessState,
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (ctx, state) {
          var bloc = AccountBloc.get(ctx);
          // if(bloc.enableUpdate==false && bloc.enableUpdateImg==false)return const SizedBox.shrink();
          if (state is UpdateProfileState && state.response.isLoad == true) {
            return const CircularProgressIndicator();
          }
          return Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(10),
            child: CustomButton(
              height: 34.w,
              width: 250.w,
              widget: CustomText(
                text:
                    bloc.enableUpdate == false && bloc.enableUpdateImg == false
                        ? translate("app_bar.edit")
                        : translate("button.save"),
                fontSize: AppStyle.small.sp,
                fontWeight: FontWeight.w600,
                color: DMUtil.getWC(),
              ),
              color: DMUtil.getPC(),
              onPressed: () {
                if (bloc.enableUpdate == false &&
                    bloc.enableUpdateImg == false) {
                  bloc.add(const EnableUpdateProfileEvent());
                  return;
                }
                if (Util.isNurse() || Util.isAssistant() || Util.isDoctor()) {
                  if (bloc.currentService != null && bloc.priceTxt != null) {
                    bloc.servicesList ??= [];
                    var item = ServicesModel(
                        id: bloc.currentService!.id,
                        value: bloc.priceTxt.toString());
                    int index = bloc.servicesList!
                        .indexWhere((element) => element.id == item.id);
                    if (index != -1) bloc.servicesList!.removeAt(index);
                    bloc.servicesList!.add(item);
                    if (Util.isDoctor()) {
                      bloc.add(UpdateDoctorDataEvent(
                          servicesList: bloc.servicesList!));
                    } else {
                      bloc.add(UpdateNurseDataEvent(
                          servicesList: bloc.servicesList!));
                    }
                  }
                  if (bloc.avatar != null) {
                    bloc.add(UpdateProfileEvent(user: {
                      if (bloc.avatar != null) 'avatar': bloc.avatar?.path
                    }));
                  }
                  if ((bloc.currentService == null || bloc.priceTxt == null) &&
                      bloc.avatar == null) {
                    bloc.add(const EnableUpdateProfileEvent(isSave: true));
                  }
                } else {
                  if (bloc.currentMedicalConditions.trim() == "" &&
                      bloc.currentPublication.trim() == "" &&
                      bloc.avatar == null) {
                    bloc.add(const EnableUpdateProfileEvent(isSave: true));
                    return;
                  }
                }

                bloc.add(UpdateProfileEvent(user: {
                  if (bloc.currentMedicalConditions != "")
                    'medical_conditions': bloc.currentMedicalConditions,
                  if (bloc.currentPublication != "")
                    'publications': bloc.currentPublication,
                  if (bloc.avatar != null) 'avatar': bloc.avatar?.path
                }));
              },
            ),
          );
        },
      ),
    );
  }
}
