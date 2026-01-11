import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/search/presentation/bloc/search_bloc.dart';
import 'package:icare/features/search/presentation/bloc/search_event.dart';
import 'package:icare/features/search/presentation/bloc/search_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class ServiceSelector extends StatelessWidget {
  final ExpansibleController? controller;
  const ServiceSelector({super.key, this.controller});

  String _getProviderTypeText(String? type) {
    if (type == null || type.isEmpty) return "";

    switch (type.toLowerCase()) {
      case 'nurse':
        return translate("nurse.nurse");
      case 'assistant':
        return translate("nurse.assistant");
      case 'doctor':
        return translate("doctor.doctor");
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (ctx, searchState) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, accountState) {
            var accountBloc = AccountBloc.get(context);
            var searchBloc = SearchBloc.get(context);

            // Get the appropriate list based on provider type
            List<ServicesModel> servicesList;

            if (searchBloc.selectedProviderType == 'doctor') {
              // For doctors, convert specialties to ServicesModel format
              servicesList = accountBloc.allSpecialtiesList.map((specialty) {
                return ServicesModel(
                  id: specialty.id,
                  value: specialty.title,
                  name: specialty.title,
                  userType: 'doctor',
                );
              }).toList();
            } else {
              // For nurses and assistants, use services list
              servicesList = accountBloc.allServiceList;
            }

            // If no services, return empty widget (user must select provider type first)
            // But if loading, maybe show indicator? For now, keep as is.
            if (servicesList.isEmpty && accountState is! ProfileLoadingState) {
              return const SizedBox.shrink();
            }

            if (accountState is ProfileLoadingState && servicesList.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Center(
                    child: CircularProgressIndicator(color: DMUtil.getPC())),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Show selected provider type info
                if (searchBloc.selectedProviderType != null)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                    margin: EdgeInsets.only(bottom: 8.h),
                    decoration: BoxDecoration(
                      color: DMUtil.getPC().withAlpha(25),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: DMUtil.getPC().withAlpha(100),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: DMUtil.getPC(),
                          size: 16.w,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: CustomText(
                            text:
                                '${translate("search.services_for")} ${_getProviderTypeText(searchBloc.selectedProviderType)} (${servicesList.length} ${translate("search.services_available")})',
                            fontSize: AppStyle.small.sp,
                            color: DMUtil.getDC(),
                          ),
                        ),
                      ],
                    ),
                  ),

                ExpansionTile(
                  controller: controller,
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                  initiallyExpanded: false,
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Icon(
                        Icons.medical_services_outlined,
                        color: DMUtil.getPC(),
                        size: 20.w,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: CustomText(
                          text: searchBloc.selectedServices.isEmpty
                              ? translate("search.select_service")
                              : "${translate("search.select_service")} (${searchBloc.selectedServices.length})",
                          fontSize: AppStyle.average.sp,
                          fontWeight: FontWeight.w600,
                          color: DMUtil.getDC(),
                        ),
                      ),
                    ],
                  ),
                  children: [
                    SizedBox(height: 10.h),
                    // Show message if no services available
                    if (servicesList.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 16.w),
                        child: Column(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: DMUtil.getD2C(),
                              size: 40.w,
                            ),
                            SizedBox(height: 10.h),
                            CustomText(
                              text: translate("search.no_services_for_type"),
                              fontSize: AppStyle.average.sp,
                              color: DMUtil.getD2C(),
                              alignCenter: true,
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: 220.h,
                        ),
                        child: ListView.separated(
                          itemCount: servicesList.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 5.h),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var service = servicesList[index];
                            bool isSelected = searchBloc.selectedServices
                                .any((s) => s.id == service.id);

                            return InkWell(
                              onTap: () {
                                // Toggle service selection
                                List<ServicesModel> newServices =
                                    List.from(searchBloc.selectedServices);

                                if (isSelected) {
                                  newServices
                                      .removeWhere((s) => s.id == service.id);
                                } else {
                                  newServices.add(service);
                                }

                                searchBloc.add(
                                    SelectServiceEvent(services: newServices));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? DMUtil.getPC().withOpacity(0.1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? DMUtil.getPC()
                                        : DMUtil.getD2C().withOpacity(0.3),
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: isSelected
                                          ? DMUtil.getPC()
                                          : DMUtil.getD2C(),
                                      size: 20,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: (service.name != null &&
                                                    service.name!.isNotEmpty)
                                                ? service.name!
                                                : service.value,
                                            fontSize: AppStyle.average.sp - 2,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            color: isSelected
                                                ? DMUtil.getPC()
                                                : DMUtil.getDC(),
                                          ),
                                          if (service.name != null &&
                                              service.name!.isNotEmpty &&
                                              service.name != service.value)
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 2.h),
                                              child: CustomText(
                                                text: service.value,
                                                fontSize: AppStyle.small.sp,
                                                color: DMUtil.getD2C(),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(height: 6.h),
                        ),
                      ),
                    if (searchBloc.selectedServices.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: ElevatedButton(
                          onPressed: () {
                            searchBloc.add(const ClearSearchFiltersEvent());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade50,
                            foregroundColor: Colors.red,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.clear, size: 16),
                              SizedBox(width: 6.w),
                              CustomText(
                                text: translate("search.clear_filters"),
                                fontSize: AppStyle.small.sp,
                                color: Colors.red,
                                // fontSize: AppStyle.small.sp,
                                // color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
