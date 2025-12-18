import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/home/presentation/widgets/specialists/home_specialists_list.dart';
import 'package:icare/features/home/presentation/widgets/view_all.dart';
import 'package:icare/features/nurse/presentation/screens/vertical_specialists_list.dart';

class ViewAllSpecialists extends StatelessWidget {
  const ViewAllSpecialists({super.key});

  @override
  Widget build(BuildContext context) {
    return Util.isNurse() || Util.isAssistant() || Util.isDoctor()
        ? SizedBox(
            height: 100.w,
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ViewAllRow(
                  title: translate("icare.visit_specialists"),
                  fn: () =>
                      Util.pushPage(const AllSpecialistsScreen(), context),
                ),
                const SizedBox(
                  height: 10,
                ),
                const HomeSpecialistsList(),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
  }
}
