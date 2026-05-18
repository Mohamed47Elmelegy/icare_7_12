import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/bloc/services_bloc.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/search/presentation/bloc/search_bloc.dart';
import 'package:icare/features/search/presentation/bloc/search_event.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class ServiceDropdown extends StatelessWidget {
  const ServiceDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, accountState) {
        var servicesBloc = ServicesBloc.get(ctx);
        var searchBloc = SearchBloc.get(ctx);

        // Services are already filtered by user_type from the API
        List<ServicesModel> availableServices = servicesBloc.allServiceList;

        if (servicesBloc.allServiceList.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            border: Border.all(color: DMUtil.getD2C()),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: searchBloc.selectedServices.isEmpty
                        ? translate("search.select_service")
                        : "${searchBloc.selectedServices.length} ${translate("search.services_selected")}",
                    fontSize: AppStyle.small.sp,
                    color: DMUtil.getD2C(),
                  ),
                  PopupMenuButton<ServicesModel>(
                    icon: Icon(Icons.arrow_drop_down, color: DMUtil.getD2C()),
                    onSelected: (service) {
                      // Toggle service selection
                      List<ServicesModel> newServices =
                          List.from(searchBloc.selectedServices);

                      if (newServices.any((s) => s.id == service.id)) {
                        newServices.removeWhere((s) => s.id == service.id);
                      } else {
                        newServices.add(service);
                      }

                      searchBloc.add(SelectServiceEvent(services: newServices));
                    },
                    itemBuilder: (BuildContext context) {
                      return availableServices.map((service) {
                        final isSelected = searchBloc.selectedServices
                            .any((s) => s.id == service.id);

                        return PopupMenuItem<ServicesModel>(
                          value: service,
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: isSelected
                                    ? DMUtil.getPC()
                                    : DMUtil.getD2C(),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomText(
                                  text: service.name ?? service.value,
                                  fontSize: AppStyle.small.sp,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
              if (searchBloc.selectedServices.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: searchBloc.selectedServices.map((service) {
                      return Chip(
                        label: CustomText(
                          text: service.name ?? service.value,
                          fontSize: AppStyle.small.sp - 2,
                          color: DMUtil.getWC(),
                        ),
                        backgroundColor: DMUtil.getPC(),
                        deleteIcon: Icon(
                          Icons.close,
                          size: 16,
                          color: DMUtil.getWC(),
                        ),
                        onDeleted: () {
                          List<ServicesModel> newServices =
                              List.from(searchBloc.selectedServices);
                          newServices.removeWhere((s) => s.id == service.id);
                          searchBloc
                              .add(SelectServiceEvent(services: newServices));
                        },
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
