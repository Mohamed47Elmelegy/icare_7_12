import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorOptionsValueRowAccount extends StatelessWidget {
  final String listType;
  const DoctorOptionsValueRowAccount({super.key, required this.listType});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, state) {
        var bloc = AccountBloc.get(ctx);
        List<String> list = [];
        if (listType == "languages" && bloc.languageList != null) {
          list = bloc.languageList!;
        } else if (listType == "education" && bloc.educationList != null) {
          list = bloc.educationList!;
        } else if (listType == "publications" &&
            bloc.publicationsList != null) {
          list = bloc.publicationsList!;
        } else if (listType == "courses" && bloc.coursesList != null) {
          list = bloc.coursesList!;
        } else if (listType == "emergency_contacts" &&
            bloc.emergencyContactsList != null) {
          list = bloc.emergencyContactsList!;
        }
        if (list.isEmpty) return const SizedBox.shrink();
        return GridView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 4.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.h,
            mainAxisSpacing: 10.h,
            childAspectRatio: 6.w,
            // mainAxisExtent: 100.h,
          ),
          itemBuilder: (BuildContext context, int index) {
            var item = list[index];
            return Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1))),
                  child: CustomText(
                    text: item,
                    fontSize: AppStyle.small.sp,
                    fontWeight: FontWeight.w600,
                    isEllipsis: true,
                    maxLine: 1,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                if (listType == "emergency_contacts") ...[
                  InkWell(
                    onTap: () => Util.sendSms(item),
                    child: Icon(
                      Icons.message_outlined,
                      color: DMUtil.getPC(),
                      size: 18.w,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () => Util.call(item),
                    child: Icon(
                      Icons.call,
                      color: DMUtil.getPC(),
                      size: 18.w,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
                InkWell(
                  onTap: () {
                    int index = list.indexWhere((element) => element == item);
                    if (index == -1) return;
                    list.removeAt(index);
                    if (listType == "languages") {
                      bloc.add(UpdateDoctorDataEvent(languageList: list));
                    } else if (listType == "education") {
                      bloc.add(UpdateDoctorDataEvent(educationList: list));
                    } else if (listType == "publications") {
                      bloc.add(UpdateDoctorDataEvent(publicationsList: list));
                    } else if (listType == "courses") {
                      bloc.add(UpdateDoctorDataEvent(coursesList: list));
                    } else if (listType == "emergency_contacts") {
                      bloc.add(
                          UpdateDoctorDataEvent(emergencyContactsList: list));
                    }
                  },
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                    size: 15.w,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
