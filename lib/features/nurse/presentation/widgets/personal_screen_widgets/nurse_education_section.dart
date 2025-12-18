import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/dot_with_title.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_state.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';

class NurseEducationSection extends StatelessWidget {
  const NurseEducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NurseBloc, NurseState>(
      builder: (ctx, state) {
        var bloc = NurseBloc.get(ctx);
        var currentNurse = bloc.currentNurse;
        if (currentNurse == null || currentNurse.educationList == null) {
          return const SizedBox.shrink();
        }
        var list = currentNurse.educationList;
        if (list!.isEmpty) return const SizedBox.shrink();
        return GridView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 4.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.h,
            mainAxisSpacing: 1.h,
            childAspectRatio: 4.w,
            // mainAxisExtent: 100.h,
          ),
          itemBuilder: (BuildContext context, int index) {
            var item = list[index];
            return DotWithTitleView(
              title: item,
              titleWidth: 140,
            );
          },
        );
      },
    );
  }
}
