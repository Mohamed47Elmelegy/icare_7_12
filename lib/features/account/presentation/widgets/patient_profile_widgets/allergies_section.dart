import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/add_new_allergies.dart';
import 'package:icare/features/account/presentation/widgets/patient_profile_widgets/dot_with_title.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AllergiesSection extends StatelessWidget {
  const AllergiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        CustomText(
          text: translate("profile.allergies"),
          fontSize: AppStyle.small.sp,
          fontWeight: FontWeight.w600,
          color: DMUtil.getDC(),
        ),
        const SizedBox(
          height: 5,
        ),
        BlocBuilder<AccountBloc, AccountState>(
          builder: (ctx, state) {
            var bloc = AccountBloc.get(ctx);
            var user = bloc.currentUser;
            if (user == null || user.allergiesList == null) {
              return const SizedBox.shrink();
            }
            var list = user.allergiesList;
            return Column(
              children: [
                GridView.builder(
                  itemCount: list!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // crossAxisSpacing: 10.h,
                    // mainAxisSpacing: 10.h,
                    childAspectRatio: 7.w,
                    // mainAxisExtent: 246.h,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    var item = list[index];
                    return DotWithTitleAllergies(
                      title: item.value,
                      titleWidth: 60,
                    );
                  },
                ),
                SizedBox(
                  height: 20.w,
                ),
                if (bloc.enableUpdate) const AddNewAllergiesWidget(),
              ],
            );
          },
        ),
      ],
    );
  }
}
