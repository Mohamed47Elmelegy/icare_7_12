import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/root_app/bloc/root_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqsListWidget extends StatelessWidget {
  const FaqsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootBloc, RootState>(
      builder: (ctx, state) {
        var list = [];
        if (list.isEmpty) return const SizedBox.shrink();
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10),
          itemBuilder: (ctx, index) {
            var item = list[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    text: item.title.toString(),
                    color: DMUtil.getD2C(),
                    fontWeight: FontWeight.w600,
                    fontSize: AppStyle.average.sp + 2),
                const SizedBox(
                  height: 10,
                ),
                if (item.faqList != null && item.faqList!.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      var smallItem = item.faqList![index];
                      return Card(
                          elevation: 3,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: ExpansionTile(
                            collapsedIconColor: DMUtil.getDC(),
                            iconColor: DMUtil.getRED(),
                            title: Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.w),
                              child: CustomText(
                                text: smallItem.title.toString(),
                                color: DMUtil.getDC(),
                                fontSize: AppStyle.small.sp,
                                maxLine: 3,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomText(
                                    text: smallItem.content.toString(),
                                    color: DMUtil.getD2C(),
                                    fontSize: AppStyle.average.sp),
                              ),
                            ],
                          ));
                    },
                    separatorBuilder: (ctx, index) => SizedBox(
                      height: 10.w,
                    ),
                    itemCount: item.faqList!.length,
                  )
              ],
            );
          },
          separatorBuilder: (ctx, state) => const SizedBox(
            height: 30,
          ),
          itemCount: list.length,
        );
      },
    );
  }
}
