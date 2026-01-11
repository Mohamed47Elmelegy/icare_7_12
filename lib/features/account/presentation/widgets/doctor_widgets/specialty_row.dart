import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

/// Row widget to display a specialty with selection indicator and remove button
class SpecialtyRow extends StatelessWidget {
  final int specialtyID;
  final String specialtyName;
  final bool isSelected;

  const SpecialtyRow({
    super.key,
    required this.specialtyID,
    required this.specialtyName,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomText(
              text: specialtyName,
              fontSize: AppStyle.small.sp,
              fontWeight: FontWeight.w600,
              color: DMUtil.getDC(),
            ),
          ],
        ),
        BlocBuilder<AccountBloc, AccountState>(
          builder: (ctx, state) {
            var bloc = AccountBloc.get(ctx);

            if (bloc.enableUpdate) {
              return InkWell(
                onTap: () => bloc.add(
                  ModifyCurrentService(
                    item: ServicesModel(
                      id: specialtyID,
                      value: specialtyName,
                    ),
                    isRemove: true,
                  ),
                ),
                child: CircleAvatar(
                  radius: 10.w,
                  backgroundColor: DMUtil.getWC(),
                  child: Icon(
                    Icons.remove,
                    size: 15.w,
                    color: DMUtil.getRED(),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
