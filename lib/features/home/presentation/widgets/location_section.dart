import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/core/styles/my_fonts.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:icare/features/locations/presentation/bloc/locations_state.dart';
import 'package:icare/features/locations/presentation/screens/add_location.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class LocationSectionWidget extends StatelessWidget {
  const LocationSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () => Util.pushPage(const AddNewLocationScreen(), context),
          child: CustomText(
            text: translate("location.add_current_location"),
            color: Colors.black,
            fontSize: AppStyle.average.sp - 1,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        BlocBuilder<LocationsBloc, LocationsState>(builder: (ctx, state) {
          var bloc = LocationsBloc.get(ctx);
          return SizedBox(
            width: double.infinity,
            child: bloc.currentCheckOutLocation != null
                ? Text.rich(
                    TextSpan(
                        text: "${translate("location.delivery_to")} ",
                        style: TextStyle(
                            color: kText1,
                            fontWeight: FontWeight.w700,
                            fontFamily: primaryFontReg,
                            fontSize: AppStyle.small.sp),
                        children: [
                          TextSpan(
                            text: bloc.currentCheckOutLocation!.address1,
                            style: TextStyle(
                                color: kText1,
                                fontWeight: FontWeight.w400,
                                fontFamily: primaryFontReg,
                                fontSize: AppStyle.verySmall.sp,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ]),
                    overflow: TextOverflow.ellipsis,
                  )
                : const SizedBox.shrink(),
          );
        }),
      ],
    );
  }
}
