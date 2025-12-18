import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_state.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class NurseLanguagesRow extends StatelessWidget {
  const NurseLanguagesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NurseBloc, NurseState>(
      builder: (ctx, state) {
        var bloc = NurseBloc.get(ctx);
        var currentNurse = bloc.currentNurse;
        if (currentNurse == null || currentNurse.languageList == null) {
          return const SizedBox.shrink();
        }
        var list = currentNurse.languageList;
        if (list!.isEmpty) return const SizedBox.shrink();
        return GridView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 1.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.h,
            mainAxisSpacing: 10.h,
            childAspectRatio: 4.w,
            // mainAxisExtent: 100.h,
          ),
          itemBuilder: (BuildContext context, int index) {
            var item = list[index];
            var flag = "";
            if (item.toLowerCase().contains("english") ||
                item.toLowerCase().contains("eng")) {
              flag = "🇬🇧";
            }
            if (item.toLowerCase().contains("french") ||
                item.toLowerCase().contains("france")) {
              flag = "🇫🇷";
            }
            if (item.toLowerCase().contains("german")) flag = "🇧🇪";
            if (item.toLowerCase().contains("arabic") ||
                item.toLowerCase().contains("ar")) {
              flag = "🇪🇬";
            }
            return CustomText(
              text: "$flag $item",
              fontSize: AppStyle.small.sp,
              fontWeight: FontWeight.w600,
              color: DMUtil.getD2C(),
            );
          },
        );
      },
    );
  }
}
