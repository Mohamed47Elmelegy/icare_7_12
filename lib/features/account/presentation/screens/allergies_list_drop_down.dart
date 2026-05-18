import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/categories/data/models/allergies.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_bloc.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_event.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AllergiesListDropDown extends StatefulWidget {
  final double width;
  const AllergiesListDropDown({super.key, this.width = 110});

  @override
  State<AllergiesListDropDown> createState() => _AllergiesListDropDownState();
}

class _AllergiesListDropDownState extends State<AllergiesListDropDown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width.w,
      decoration: BoxDecoration(
          color: DMUtil.getWC(),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: DMUtil.getOpacity())),
      child: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (ctx, state) {
          var bloc = CategoriesBloc.get(ctx);
          var list = bloc.allAllergies;
          if (list.isEmpty) return const SizedBox.shrink();
          var currentItem = bloc.currentAllergies;
          return DropdownButton<AllergiesModel>(
            value: null,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 10,
            menuMaxHeight: 250.h,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomText(
                text: currentItem == null
                    ? translate("doctor.allergies")
                    : currentItem.value,
                fontSize: AppStyle.small.sp,
                color: DMUtil.getD2C(),
              ),
            ),
            isExpanded: true,
            style: TextStyle(color: DMUtil.getD2C()),
            underline: const SizedBox(),
            onChanged: (AllergiesModel? newValue) =>
                bloc.add(ChangeCurrentAllergies(item: newValue!)),
            items: list
                .map<DropdownMenuItem<AllergiesModel>>((AllergiesModel item) {
              return DropdownMenuItem<AllergiesModel>(
                value: item,
                child: CustomText(
                  text: item.value.toString(),
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
