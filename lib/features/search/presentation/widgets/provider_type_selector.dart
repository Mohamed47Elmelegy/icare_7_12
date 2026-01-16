import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/strings/enum/user_enum.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/search/presentation/bloc/search_bloc.dart';
import 'package:icare/features/search/presentation/bloc/search_event.dart';
import 'package:icare/features/search/presentation/bloc/search_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class ProviderTypeSelector extends StatelessWidget {
  final Color? txtColor;
  final Color? selectedColor;

  const ProviderTypeSelector({
    super.key,
    this.txtColor,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (ctx, state) {
        var bloc = SearchBloc.get(ctx);
        return SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildProviderOption(
                        context: context,
                        bloc: bloc,
                        type: UserEnum.NURSE.name.toLowerCase(),
                        label: translate("nurse.nurse"),
                        selectedColor: selectedColor,
                      ),
                      SizedBox(width: 15.w),
                      _buildProviderOption(
                        context: context,
                        bloc: bloc,
                        type: UserEnum.ASSISTANT.name.toLowerCase(),
                        label: translate("nurse.assistant"),
                        selectedColor: selectedColor,
                      ),
                      // SizedBox(width: 15.w),
                      // _buildProviderOption(
                      //   context: context,
                      //   bloc: bloc,
                      //   type: 'doctor',
                      //   label: translate("doctor.doctor"),
                      //   selectedColor: selectedColor,
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProviderOption({
    required BuildContext context,
    required SearchBloc bloc,
    required String type,
    required String label,
    Color? selectedColor,
  }) {
    final isSelected = bloc.selectedProviderType == type;

    return InkWell(
      onTap: () => bloc.add(SelectProviderTypeEvent(providerType: type)),
      child: Row(
        children: [
          SelectedCircle(
            selected: isSelected,
            selectedColor: selectedColor,
          ),
          const SizedBox(width: 10),
          CustomText(
            text: label,
            fontSize: AppStyle.small.sp,
          ),
        ],
      ),
    );
  }
}

class SelectedCircle extends StatelessWidget {
  final bool selected;
  final Color? selectedColor;

  const SelectedCircle({
    super.key,
    required this.selected,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? (selectedColor ?? DMUtil.getPC()) : DMUtil.getD2C(),
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedColor ?? DMUtil.getPC(),
                ),
              ),
            )
          : null,
    );
  }
}
