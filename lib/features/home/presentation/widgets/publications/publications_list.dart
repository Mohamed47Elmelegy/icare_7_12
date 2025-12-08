import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/strings/app_images.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_bloc.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_state.dart';
import 'package:icare/features/home/presentation/widgets/publications/publication_widget.dart';

class PublicationsList extends StatelessWidget {
  const PublicationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (ctx, state) {
        var bloc = CategoriesBloc.get(ctx);
        var list = bloc.publicationsList;
        if (state is FetchPublicationsLoadingState) {
          return Image.asset(AppImages.loadingGif,height: 100.w,width: double.infinity,);
        }
        if (list.isEmpty) return const SizedBox.shrink();
        return ListView.separated(
          padding: EdgeInsets.symmetric(
              vertical: 15.h, horizontal: AppStyle.paddingFromH.w),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, index) {
            var item = list[index];
            return PublicationWidget(
              item: item,
            );
          },
          separatorBuilder: (ctx, index) => Divider(
            height: 15.w,
            color: DMUtil.getOpacity(),
          ),
          itemCount: list.length,
        );
      },
    );
  }
}
