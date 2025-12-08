import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_event.dart';
import 'package:icare/features/authentication/presentation/bloc/auth_state.dart';
import 'package:icare/features/authentication/presentation/widgets/show_all_nurses.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class GenderRow extends StatelessWidget {
  final Color? txtColor;
  final Color? selectedColor;
  const GenderRow({super.key, this.txtColor, this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (ctx, state) {
        var bloc = AuthBloc.get(ctx);
        return SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              CustomText(
                text: translate("profile.gender"),
                fontSize: AppStyle.small.sp,
                color: txtColor ?? DMUtil.getDC(),
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                width: 10.w,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => bloc.add(const SwitchGenderEvent(man: true)),
                    child: Row(
                      children: [
                        SelectedCircle(
                          selected: !bloc.isWomen,
                          selectedColor: selectedColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          text: translate("profile.male"),
                          fontSize: AppStyle.small.sp,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: 20.w,
                  ),

                  InkWell(
                    onTap: () => bloc.add(const SwitchGenderEvent(man: false)),
                    child: Row(
                      children: [
                        SelectedCircle(
                          selected: bloc.isWomen,
                          selectedColor: selectedColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          text: translate("profile.female"),
                          fontSize: AppStyle.small.sp,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: 20.w,
                  ),

                  // const ShowAllNursesWidget(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class SelectedCircle extends StatelessWidget {
  final bool selected;
  final Color? selectedColor;
  const SelectedCircle({super.key, required this.selected, this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.w),
        border: Border.all(width: 1, color: (selectedColor ?? DMUtil.getDC())),
        color: DMUtil.getWC(),
      ),
      child: Icon(
        Icons.circle,
        color: selected ? (selectedColor ?? DMUtil.getDC()) : DMUtil.getWC(),
        size: 15.w,
      ),
    );
  }
}
