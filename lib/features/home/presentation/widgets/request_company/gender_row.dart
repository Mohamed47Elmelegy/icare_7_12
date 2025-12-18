import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/authentication/presentation/widgets/gender_row.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class GenderRowRequestForm extends StatelessWidget {
  const GenderRowRequestForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(builder: (ctx, state) {
      var bloc = BookingBloc.get(ctx);
      return Row(
        children: [
          InkWell(
            onTap: () => bloc.add(
                const UpdateRequestFormDataEvent(data: {'gender': 'male'})),
            child: Row(
              children: [
                SelectedCircle(
                  selected: bloc.gender == 'male',
                  selectedColor: kPrimary,
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomText(
                  text: translate("profile.male"),
                  fontSize: AppStyle.small.sp,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () => bloc.add(
                const UpdateRequestFormDataEvent(data: {'gender': 'female'})),
            child: Row(
              children: [
                SelectedCircle(
                  selected: bloc.gender == 'female',
                  selectedColor: kPrimary,
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomText(
                  text: translate("profile.female"),
                  fontSize: AppStyle.small.sp,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
