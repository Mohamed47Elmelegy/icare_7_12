import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/features/home/presentation/widgets/specialists/specialist_card.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_state.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';

class HomeSpecialistsList extends StatelessWidget {
  const HomeSpecialistsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.w,
      child: BlocBuilder<NurseBloc, NurseState>(
        builder: (ctx, state) {
          var bloc = NurseBloc.get(ctx);
          var list = bloc.nursesList;
          if (list.isEmpty) return const SizedBox.shrink();
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (ctx, index) {
              var item = list[index];
              if (item.userData == null) return const SizedBox.shrink();
              return SpecialistCard(
                nurse: item,
              );
            },
            separatorBuilder: (ctx, index) => const SizedBox(
              width: 7,
            ),
            itemCount: list.length > 10 ? 10 : list.length,
          );
        },
      ),
    );
  }
}
