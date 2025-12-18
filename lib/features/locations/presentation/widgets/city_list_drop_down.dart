import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:icare/features/locations/presentation/bloc/locations_event.dart';
import 'package:icare/features/locations/presentation/bloc/locations_state.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/setting/data/models/city_model.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class CityListDropDown extends StatelessWidget {
  const CityListDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: DMUtil.getWC(),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: DMUtil.getOpacity())),
      child: BlocBuilder<LocationsBloc, LocationsState>(
        builder: (ctx, state) {
          var bloc = LocationsBloc.get(ctx);
          var rootBloc = RootBloc.get(context);
          int gIndex = rootBloc.governoratesList.indexWhere(
              (element) => element.title.trim() == bloc.governorate.toString());
          List<CityModel> cities = [];
          if (gIndex != -1) {
            cities = rootBloc.citiesList
                .where((element) =>
                    rootBloc.governoratesList[gIndex].id ==
                    element.governorateID)
                .toList();
          }
          return DropdownButton<String>(
            value: null,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 10,
            menuMaxHeight: 250.h,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomText(
                text: bloc.city ?? translate("map.select_city"),
                fontSize: AppStyle.small.sp,
                color: DMUtil.getD2C(),
              ),
            ),
            isExpanded: true,
            style: TextStyle(color: DMUtil.getD2C()),
            underline: const SizedBox(),
            onChanged: (String? newValue) =>
                bloc.add(UpdateCurrentLocationEvent(city: newValue.toString())),
            items: cities.map<DropdownMenuItem<String>>((CityModel value) {
              return DropdownMenuItem<String>(
                value: value.title.toString(),
                child: CustomText(
                  text: value.title,
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
