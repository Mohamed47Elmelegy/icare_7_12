import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_event.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_state.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/nurse/presentation/widgets/nurse_extra_options_card.dart';
import 'package:icare/features/nurse/presentation/widgets/nurse_profile_details_image.dart';
import 'package:icare/features/nurse/presentation/widgets/rate_nurse_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';

class RateNurseBottomSheet extends StatelessWidget {
  const RateNurseBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    return SizedBox(
      height: 450.w,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              color: Colors.white.withValues(alpha: 0.9),
              height: 400.w,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60.w,
                    ),
                    BlocBuilder<NurseBloc, NurseState>(
                      builder: (ctx, state) {
                        var bloc = NurseBloc.get(ctx);
                        var currentNurse = bloc.currentNurse;
                        if (currentNurse == null ||
                            currentNurse.userData == null) {
                          return const SizedBox.shrink();
                        }
                        return CustomText(
                          text: currentNurse.userData!.userName.toString(),
                          fontWeight: FontWeight.w600,
                          fontSize: AppStyle.small.sp,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SmallNurseBoxValues(
                      isRate: true,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomText(
                      text: translate("icare.how_was_your_experience"),
                      fontSize: AppStyle.small.sp,
                    ),
                    Align(
                      child: RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 30.w,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: kStarColor,
                        ),
                        onRatingUpdate: (rating) => NurseBloc.get(context)
                            .add(UpdateRateDataEvent(rateValue: rating)),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: CustomTextFromField(
                        hasBorder: false,
                        borderWidth: 0,
                        maxLines: 10,
                        borderColor: Colors.transparent,
                        labelText: '',
                        height: 120,
                        hintText: translate("products.add_comment"),
                        radius: 10,
                        onChanged: (val) => NurseBloc.get(context).add(
                            UpdateRateDataEvent(
                                rateTxt: val.toString().trim())),
                        onFieldSubmitted: (val) {},
                        textEditingController: textEditingController,
                        cursorColor: kPrimary,
                        validator: () {},
                        prefixIcon: null,
                        obscureText: false,
                        isLabelError: false,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const RateNurseButton(),
                    const SizedBox(
                      height: 250,
                    ),
                  ],
                ),
              )),
          const Align(
            alignment: Alignment.topCenter,
            child: NurseProfileDetailsImage(
              isTopPadding: false,
            ),
          ),
        ],
      ),
    );
  }
}
