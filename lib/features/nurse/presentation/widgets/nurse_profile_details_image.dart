import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_state.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';

class NurseProfileDetailsImage extends StatelessWidget {
  final bool isTopPadding;
  const NurseProfileDetailsImage({super.key, this.isTopPadding = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: isTopPadding ? 132.w : 0,
          bottom: isTopPadding == false ? 230.w : 0),
      child: BlocBuilder<NurseBloc, NurseState>(
        builder: (ctx, state) {
          var bloc = NurseBloc.get(ctx);
          var currentNurse = bloc.currentNurse;
          if (currentNurse == null || currentNurse.userData == null) {
            return const SizedBox.shrink();
          }
          String img = currentNurse.userData!.image.toString();
          if (img.trim() == "") {
            return CircleAvatar(
              radius: 50.w,
              backgroundColor: Colors.transparent,
              backgroundImage: const AssetImage(AppImages.nurse),
            );
          }
          return CircleAvatar(
            radius: 50.w,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(img),
          );
        },
      ),
    );
  }
}
