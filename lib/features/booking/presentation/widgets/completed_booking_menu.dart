// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/authentication/domain/entities/user_entity.dart';
import 'package:icare/features/booking/domain/entities/order.dart';
import 'package:icare/features/search/domain/entities/searchable_entity.dart';
import 'package:icare/features/nurse/domain/entities/nurse_entity.dart';
import 'package:icare/features/nurse/presentation/bloc/nurse_event.dart';
import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
import 'package:icare/features/nurse/presentation/widgets/rate_nurse_bottom_sheet.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/review.dart';

class CompletedBookingMenuWidget extends StatelessWidget {
  final Booking item;
  final SearchableEntity orderNurse;
  final UserService currentUser;
  const CompletedBookingMenuWidget(
      {super.key,
      required this.item,
      required this.orderNurse,
      required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          if (currentUser.userType.toString().toLowerCase() == "customer") ...[
            // Only show rating option if the provider is a nurse
            if (orderNurse.providerType.toLowerCase() == 'nurse')
              PopupMenuButton(
                icon: Icon(
                  Icons.info_outline,
                  color: DMUtil.getPC4(),
                  size: 20.w,
                ),
                itemBuilder: (_) => <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                    value: 'rate',
                    child: CustomText(
                        text: translate("icare.rate_nurse"),
                        fontSize: AppStyle.small.sp),
                  ),
                ],
                onSelected: (val) {
                  // Cast to NurseEntity since we've verified it's a nurse
                  if (orderNurse is NurseEntity) {
                    NurseBloc.get(context).add(UpdateCurrentNurseEvent(
                        nurse: orderNurse as NurseEntity));
                    if (val.toString().trim() == "rate") {
                      showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        useSafeArea: true,
                        backgroundColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25)),
                        ),
                        builder: (ctx) {
                          return const RateNurseBottomSheet();
                        },
                      );
                    }
                  }
                },
              ),
          ] else ...[
            ReviewsWidget(amount: 150, color: DMUtil.getReviewColor()),
          ],
          SizedBox(
            width: 20.w,
          ),
          CustomText(
            text: "${translate("order.order_has_done")} ✓",
            color: DMUtil.getPC4(),
            fontWeight: FontWeight.bold,
            fontSize: AppStyle.verySmall.sp - 3,
          ),
        ],
      ),
    );
  }
}
