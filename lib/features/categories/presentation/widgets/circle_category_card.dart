import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/categories/domain/entities/categories_entity.dart';
import 'package:icare/features/shared_widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_event.dart';
import 'package:icare/features/categories/presentation/screens/category_products.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_bloc.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleCategoryCard extends StatelessWidget {
  final CategoriesEntity item;
  const CircleCategoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        CategoriesBloc.get(context)
            .add(ChangeCategoriesEvent(categoriesModel: item));
        Util.pushPage(const CategoryProductsScreen(), context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (DMUtil.currentThemeIsDark() &&
              item.darkIcon != null &&
              item.darkIcon.toString().trim() != "") ...[
            SvgPicture.network(
              item.darkIcon!,
              height: 50.h,
              fit: BoxFit.contain,
              placeholderBuilder: (context) => SizedBox(
                height: 50.h,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorBuilder: (context, error, stackTrace) => SvgIconWidget(
                iconUrl: item.iconPath,
              ),
            ),
          ] else if (!DMUtil.currentThemeIsDark() &&
              item.lightIcon != null &&
              item.lightIcon.toString().trim() != "") ...[
            SvgPicture.network(
              item.lightIcon!,
              height: 50.h,
              fit: BoxFit.contain,
              placeholderBuilder: (context) => SizedBox(
                height: 50.h,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorBuilder: (context, error, stackTrace) => SvgIconWidget(
                iconUrl: item.iconPath,
              ),
            ),
          ] else ...[
            SvgIconWidget(
              iconUrl: item.iconPath,
            ),
          ],
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 30.h + 12.w,
            width: 60.w,
            child: CustomText(
              text: item.title.toString(),
              fontSize: AppStyle.small.sp,
              alignCenter: true,
              maxLine: item.title.toString().contains(" ") ? 2 : 1,
            ),
          )
        ],
      ),
    );
  }
}
