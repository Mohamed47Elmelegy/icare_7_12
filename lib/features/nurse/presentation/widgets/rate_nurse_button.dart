import 'package:flutter/material.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_event.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_state.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class RateNurseButton extends StatelessWidget {
  const RateNurseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NurseBloc, NurseState>(
      listener: (ctx, state) {
        if (state is AddNurseRateSuccessfullyState) {
          SnackBarBuilder.showFeedBackMessage(
              context, translate("toast.thanks_for_rating"), Colors.green);
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<NurseBloc, NurseState>(
        builder: (ctx, state) {
          var bloc = NurseBloc.get(ctx);
          var currentNurse = bloc.currentNurse;
          if (currentNurse == null) return const SizedBox.shrink();
          if (state is RateDataLoadingState) {
            return CircularProgressIndicator(
              color: DMUtil.getPC(),
            );
          }
          return CustomButton(
            height: 30.w,
            width: 140.w,
            widget: CustomText(
              text: translate("button.submit"),
              color: Colors.white,
              fontSize: AppStyle.small.sp,
            ),
            color: DMUtil.getPC(),
            onPressed: () {
              if (bloc.rateTxt.trim() != "" && bloc.rateValue != 0) {
                bloc.add(RateNurseEvent(data: {
                  'nurse_id': bloc.currentNurse!.id.toString(),
                  'user_id': Util.getUserID().toString(),
                  'rating': bloc.rateValue.toString(),
                  'comment': bloc.rateTxt.toString()
                }));
              } else {
                SnackBarBuilder.showFeedBackMessage(
                    context, translate("toast.field_empty"), Colors.red);
              }
            },
          );
        },
      ),
    );
  }
}
