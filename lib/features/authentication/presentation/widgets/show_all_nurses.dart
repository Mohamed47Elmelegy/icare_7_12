import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/authentication/presentation/widgets/gender_row.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_event.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_state.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class ShowAllNursesWidget extends StatelessWidget {
  const ShowAllNursesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NurseBloc, NurseState>(
      builder: (ctx, state) {
        var nurseBloc = NurseBloc.get(ctx);
        return InkWell(
          onTap: () {
            // nurseBloc.add(const ShowAllNursesEvent());
            nurseBloc.add(SetNurseOnMapEvent(
                ctx: context, showAllNurses: !nurseBloc.showAllNurses));
          },
          child: Row(
            children: [
              SelectedCircle(
                selected: nurseBloc.showAllNurses,
                selectedColor: DMUtil.getPC(),
              ),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                text: translate("search.all_nurses"),
                fontSize: AppStyle.small.sp,
              ),
            ],
          ),
        );
      },
    );
  }
}
