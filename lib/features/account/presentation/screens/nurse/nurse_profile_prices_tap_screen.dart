import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/widgets/nurse_widgets/service_list_drop_down.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/features/nurse/presentation/widgets/prices_screen_widgets/service_price_row.dart';

class NurseProfilePricesTapScreen extends StatelessWidget {
  const NurseProfilePricesTapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, state) {
        var bloc = AccountBloc.get(ctx);
        var list = bloc.servicesList;
        return Column(
          children: [
            if (bloc.enableUpdate) ...[
              const ServicesListDropDown(
                width: double.infinity,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
            if (list != null && list.isNotEmpty) ...[
              ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    var item = list[index];

                    // Check if user is doctor to use specialties list
                    bool isDoctor = bloc.currentUser?.userType == 'doctor';

                    String serviceName;
                    int serviceID;
                    bool isSelected = false;

                    if (isDoctor) {
                      // For doctors, find in specialties list
                      int ind = bloc.allSpecialtiesList
                          .indexWhere((element) => item.id == element.id);
                      if (ind == -1) return const SizedBox.shrink();
                      serviceID = bloc.allSpecialtiesList[ind].id;
                      serviceName = bloc.allSpecialtiesList[ind].title;

                      // Check if this specialty is currently selected
                      isSelected = bloc.selectedSpecialty?.id == serviceID;
                    } else {
                      // For nurses, find in services list
                      int ind = bloc.allServiceList
                          .indexWhere((element) => item.id == element.id);

                      if (ind == -1) {
                        serviceID = item.id;
                        serviceName = item.value.toString();
                      } else {
                        serviceID = bloc.allServiceList[ind].id;
                        serviceName = bloc.allServiceList[ind].value.toString();
                      }
                    }

                    return ServicePriceRowWithModify(
                      serviceID: serviceID,
                      serviceName: serviceName,
                      price: item.value.toString(),
                      isSelected: isDoctor
                          ? isSelected
                          : null, // Only show selection for doctors
                    );
                  },
                  separatorBuilder: (ctx, index) => Divider(
                        height: 25.w,
                      ),
                  itemCount: list.length),
            ],
          ],
        );
      },
    );
  }
}
