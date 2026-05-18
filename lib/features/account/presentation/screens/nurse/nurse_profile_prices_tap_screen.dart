import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/bloc/services_bloc.dart';
import 'package:icare/features/account/presentation/bloc/services_state.dart';
import 'package:icare/features/account/presentation/widgets/nurse_widgets/service_list_drop_down.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/features/nurse/presentation/widgets/prices_screen_widgets/service_price_row.dart';

class NurseProfilePricesTapScreen extends StatelessWidget {
  const NurseProfilePricesTapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, state) {
        var accountBloc = AccountBloc.get(ctx);
        var list = accountBloc.servicesList;

        return BlocBuilder<ServicesBloc, ServicesState>(
          builder: (context, servicesState) {
            var servicesBloc = ServicesBloc.get(context);

            return Column(
              children: [
                if (accountBloc.enableUpdate) ...[
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

                        bool isDoctor =
                            accountBloc.currentUser?.userType == 'doctor';

                        String serviceName;
                        int serviceID;
                        bool isSelected = false;

                        if (isDoctor) {
                          int ind = servicesBloc.allSpecialtiesList
                              .indexWhere((element) => item.id == element.id);
                          if (ind == -1) return const SizedBox.shrink();
                          serviceID = servicesBloc.allSpecialtiesList[ind].id;
                          serviceName =
                              servicesBloc.allSpecialtiesList[ind].title;

                          isSelected =
                              accountBloc.selectedSpecialty?.id == serviceID;
                        } else {
                          int ind = servicesBloc.allServiceList
                              .indexWhere((element) => item.id == element.id);

                          if (ind == -1) {
                            serviceID = item.id;
                            serviceName = item.value.toString();
                          } else {
                            serviceID = servicesBloc.allServiceList[ind].id;
                            serviceName = servicesBloc.allServiceList[ind].value
                                .toString();
                          }
                        }

                        return ServicePriceRowWithModify(
                          serviceID: serviceID,
                          serviceName: serviceName,
                          price: item.value.toString(),
                          isSelected: isDoctor ? isSelected : null,
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
      },
    );
  }
}
