import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_state.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/shared_widgets/align_child_by_row.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RateWidget extends StatelessWidget {
  const RateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AlignChildRow(
          isStart: true,
          child: ReviewsWidget(amount: 150, color: DMUtil.getReviewColor()),
        ),
        const SizedBox(width: 5,),
        BlocBuilder<NurseBloc,NurseState>(
          builder: (ctx,state){
            var bloc = NurseBloc.get(ctx);
            var nurse = bloc.currentNurse;
            if(nurse == null || nurse.reviewList==null)return const SizedBox.shrink();
            return CustomText(
              text: "(${nurse.reviewList!.length})",
              fontSize: AppStyle.small.sp,
              color: DMUtil.getD2C(),
            );
          },
        ),

      ],
    );
  }
}
