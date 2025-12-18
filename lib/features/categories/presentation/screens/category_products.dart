import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_bloc.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_state.dart';
import 'package:icare/features/root_app/widgets/bottom_nav_bar.dart';
import 'package:icare/features/search/presentation/widgets/search_widget.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DMUtil.getWC(),
      bottomNavigationBar: const BottomNavBar(
        isRoot: false,
      ),
      body: BlocBuilder<CategoriesBloc, CategoriesState>(builder: (ctx, state) {
        var bloc = CategoriesBloc.get(ctx);
        if (bloc.currentCategory == null) return const SizedBox.shrink();
        return Column(
          children: [
            GlobalAppBar(
                title: bloc.currentCategory!.title.toString(),
                leadingIcon: BackArrowButton(
                  fn: () {
                    Navigator.of(context).pop();
                  },
                )),
            const SizedBox(
              height: 10,
            ),
            const SearchWidget(
              showDrawer: false,
            ),
          ],
        );
      }),
    );
  }
}
