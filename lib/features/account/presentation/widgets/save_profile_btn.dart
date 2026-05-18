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
import 'package:icare/features/account/presentation/bloc/services_bloc.dart';
import 'package:icare/features/account/presentation/bloc/services_state.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/setting/domain/entities/specialty_entity.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class SaveProfileBtn extends StatelessWidget {
  const SaveProfileBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AccountBloc, AccountState>(
          listener: (context, state) {},
          listenWhen: (previous, current) =>
              current is UpdateNurseDataSuccessState ||
              current is UpdateDoctorDataSuccessState,
        ),
      ],
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (ctx, state) {
          var accountBloc = AccountBloc.get(ctx);

          // Hide button when viewing Reports tab (index 2) for patients
          if (accountBloc.currentProfileTapsIndex == 2 &&
              !Util.isNurse() &&
              !Util.isAssistant()) {
            return const SizedBox.shrink();
          }

          if (state is UpdateProfileState && state.response.isLoad == true) {
            return const Center(child: CircularProgressIndicator());
          }

          return BlocBuilder<ServicesBloc, ServicesState>(
            builder: (context, servicesState) {
              var servicesBloc = ServicesBloc.get(context);

              return Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(10),
                child: CustomButton(
                  height: 34.w,
                  width: 250.w,
                  widget: CustomText(
                    text: accountBloc.enableUpdate == false &&
                            accountBloc.enableUpdateImg == false
                        ? translate("app_bar.edit")
                        : translate("button.save"),
                    fontSize: AppStyle.small.sp,
                    fontWeight: FontWeight.w600,
                    color: DMUtil.getWC(),
                  ),
                  color: DMUtil.getPC(),
                  onPressed: () {
                    if (accountBloc.enableUpdate == false &&
                        accountBloc.enableUpdateImg == false) {
                      accountBloc.add(const EnableUpdateProfileEvent());
                      return;
                    }

                    if (Util.isNurse() ||
                        Util.isAssistant() ||
                        Util.isDoctor()) {
                      // Safeguard for Doctor: Ensure priceTxt is set from service value if null
                      if (Util.isDoctor() &&
                          servicesBloc.currentService != null) {
                        servicesBloc.priceTxt =
                            servicesBloc.currentService!.value;
                      }

                      if (servicesBloc.currentService != null &&
                          servicesBloc.priceTxt != null) {
                        accountBloc.servicesList ??= [];
                        var item = ServicesModel(
                            id: servicesBloc.currentService!.id,
                            value: servicesBloc.priceTxt.toString());

                        int index = accountBloc.servicesList!
                            .indexWhere((element) => element.id == item.id);
                        if (index != -1) {
                          accountBloc.servicesList!.removeAt(index);
                        }
                        accountBloc.servicesList!.add(item);

                        if (Util.isDoctor()) {
                          accountBloc.selectedSpecialty = SpecialtyEntity(
                            id: item.id,
                            title: item.value,
                          );
                          accountBloc.add(UpdateDoctorDataEvent(
                              selectedSpecialty:
                                  accountBloc.selectedSpecialty));
                        } else {
                          accountBloc.add(UpdateNurseDataEvent(
                              servicesList: accountBloc.servicesList!));
                        }
                      }

                      if (accountBloc.avatar != null) {
                        accountBloc.add(UpdateProfileEvent(
                            user: {'avatar': accountBloc.avatar?.path}));
                      }

                      if ((servicesBloc.currentService == null ||
                              servicesBloc.priceTxt == null) &&
                          accountBloc.avatar == null) {
                        accountBloc
                            .add(const EnableUpdateProfileEvent(isSave: true));
                      }
                    } else {
                      if (accountBloc.currentMedicalConditions.trim() == "" &&
                          accountBloc.currentPublication.trim() == "" &&
                          accountBloc.avatar == null) {
                        accountBloc
                            .add(const EnableUpdateProfileEvent(isSave: true));
                        return;
                      }
                    }

                    accountBloc.add(UpdateProfileEvent(user: {
                      if (accountBloc.currentMedicalConditions != "")
                        'medical_conditions':
                            accountBloc.currentMedicalConditions,
                      if (accountBloc.currentPublication != "")
                        'publications': accountBloc.currentPublication,
                      if (accountBloc.avatar != null)
                        'avatar': accountBloc.avatar?.path
                    }));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
