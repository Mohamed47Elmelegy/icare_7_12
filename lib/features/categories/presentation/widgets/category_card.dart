import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/categories/domain/entities/categories_entity.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_bloc.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_event.dart';
import 'package:icare/features/categories/presentation/screens/category_products.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryCard extends StatelessWidget {
  final CategoriesEntity item;
  const CategoryCard({super.key,required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        CategoriesBloc.get(context).add(ChangeCategoriesEvent(categoriesModel: item));
        Util.pushPage(const CategoryProductsScreen(), context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: DMUtil.getWC(),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1.0, // soften the shadow
              spreadRadius: 0.7, //extend the shadow
              offset: Offset(
                0.01, // Move to right 10  horizontally
                0.05, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           Container(
             height: 120.h,
             width: 150.w,
             decoration:  BoxDecoration(
               borderRadius: Util.getLang()!="ar"? const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)):
                  const BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)),
               image: DecorationImage(
                 fit: BoxFit.fill,
                 image: NetworkImage(item.imgPath)
               )
             ),
           ),




            Expanded(
              child: CustomText(
                text: item.title,
                fontSize: AppStyle.large.sp - 2.w,
                alignCenter: true,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
