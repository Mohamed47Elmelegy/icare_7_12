import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/search/presentation/widgets/search_widget.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          GlobalAppBar(
            title: translate("app_bar.categories"),
          ),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppStyle.paddingFromH.w, vertical: 10),
              child: const SearchWidget()),
        ],
      ),
    );
  }
}
