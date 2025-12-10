import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_state.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/nurse/presentation/widgets/vertical_specialist_card.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class NearbyNurses extends StatelessWidget {
  const NearbyNurses({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NurseBloc, NurseState>(
      builder: (ctx, state) {
        var bloc = NurseBloc.get(ctx);
        var list = bloc.nearbyList.isEmpty ? bloc.nursesList : bloc.nearbyList;
        if (list.isEmpty) return const SizedBox.shrink();
        list.sort((a, b) {
          int distanceKMComparison =
              (a.distanceKM != null && a.distanceKM != -1 ? a.distanceKM : -1)!
                  .compareTo((b.distanceKM != null && b.distanceKM != -1
                      ? b.distanceKM
                      : -1)!);

          if (distanceKMComparison == 0) {
            return (a.distanceM ?? 0).compareTo(b.distanceM ?? 0);
          }

          return distanceKMComparison;
        });
        return Container(
          decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          width: 320.w,
          child: ExpansionTile(
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white,
            title: CustomText(
                text: translate("nurse.nearby_nurses"),
                fontSize: AppStyle.average.sp),
            children: [
              SizedBox(
                height: 260.w,
                child: ListView.separated(
                  itemCount: list.length > 6 ? 6 : list.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var item = list[index];
                    if (item.userData == null) return const SizedBox.shrink();
                    return VerticalSpecialistCard(
                      nurse: item,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
