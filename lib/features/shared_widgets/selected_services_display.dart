import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

/// Widget to display selected services with their prices
/// Used in provider cards to show which services are selected and their costs
class SelectedServicesDisplay extends StatelessWidget {
  final List<ServicesModel> selectedServices;
  final NurseEntity nurse;
  final bool compact;

  const SelectedServicesDisplay({
    super.key,
    required this.selectedServices,
    required this.nurse,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedServices.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get matching services from nurse's service list
    final matchingServices = _getMatchingServices(context);

    if (matchingServices.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6.h),
        ...matchingServices.map((service) => Padding(
              padding: EdgeInsets.only(bottom: 3.h),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 12.w,
                    color: DMUtil.getPC(),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: CustomText(
                      text: service.serviceName,
                      fontSize: AppStyle.small.sp - 2,
                      color: DMUtil.getDC(),
                      maxLine: 1,
                      isEllipsis: true,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  CustomText(
                    text: "${service.price} ${translate("icare.le")}",
                    fontSize: AppStyle.small.sp - 2,
                    fontWeight: FontWeight.w600,
                    color: DMUtil.getPC(),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  /// Get services that match both selected services and nurse's available services
  List<_ServiceWithPrice> _getMatchingServices(BuildContext context) {
    final List<_ServiceWithPrice> matching = [];

    if (nurse.servicesList == null) return matching;

    // Get all services list from AccountBloc to get service names
    final allServicesList = AccountBloc.get(context).allServiceList;

    for (var selectedService in selectedServices) {
      // Find matching service in nurse's service list to get the price
      final nurseService = nurse.servicesList!.firstWhere(
        (s) => s.id == selectedService.id,
        orElse: () => const ServicesModel(id: -1, value: ''),
      );

      if (nurseService.id != -1) {
        // Get service name from allServicesList
        final serviceFromList = allServicesList.firstWhere(
          (s) => s.id == selectedService.id,
          orElse: () => const ServicesModel(id: -1, value: ''),
        );

        // ✅ FIX: Use 'value' field as service name (API stores names in 'value')
        String serviceName;
        if (serviceFromList.id != -1) {
          // Found in allServiceList - use its value as name
          serviceName = serviceFromList.name?.isNotEmpty == true
              ? serviceFromList.name!
              : serviceFromList.value;
        } else {
          // Not in allServiceList - use selectedService's value as name
          serviceName = selectedService.name?.isNotEmpty == true
              ? selectedService.name!
              : selectedService.value;
        }

        matching.add(_ServiceWithPrice(
          serviceName: serviceName,
          price: nurseService.value.toString(),
        ));
      }
    }

    return matching;
  }
}

/// Helper class to hold service name and price
class _ServiceWithPrice {
  final String serviceName;
  final String price;

  _ServiceWithPrice({
    required this.serviceName,
    required this.price,
  });
}
