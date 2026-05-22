import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/authentication/presentation/cubit/registration_cubit.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NurseOptionsValueRow extends StatelessWidget {
  final String listType;
  const NurseOptionsValueRow({super.key, required this.listType});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (ctx, regState) {
        var regCubit = RegistrationCubit.get(ctx);
        // ---- DEBUG TRACE (registration display widget) ----
        debugPrint('[REG][display:$listType] Cubit hash: '
            '${regCubit.hashCode} | languages: ${regState.languageList}');
        // ---------------------------------------------------
        List<String> list = [];
        if (listType == "languages" && regState.languageList != null) {
          list = List.from(regState.languageList!);
        } else if (listType == "education" && regState.educationList != null) {
          list = List.from(regState.educationList!);
        } else if (listType == "publications" &&
            regState.publicationsList != null) {
          list = List.from(regState.publicationsList!);
        } else if (listType == "courses" && regState.coursesList != null) {
          list = List.from(regState.coursesList!);
        }
        if (list.isEmpty) return const SizedBox.shrink();
        return GridView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 4.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 5.h,
          ),
          itemBuilder: (BuildContext context, int index) {
            var item = list[index];
            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
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
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    final updated = List<String>.from(list);
                    updated.remove(item);
                    if (listType == "languages") {
                      regCubit.updateLanguageList(updated);
                    } else if (listType == "education") {
                      regCubit.updateEducationList(updated);
                    } else if (listType == "publications") {
                      regCubit.updatePublicationsList(updated);
                    } else if (listType == "courses") {
                      regCubit.updateCoursesList(updated);
                    }
                  },
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                    size: 15.w,
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}

class NurseOptionsValueRowAccount extends StatelessWidget {
  final String listType;
  const NurseOptionsValueRowAccount({super.key, required this.listType});

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
                      bloc.add(UpdateNurseDataEvent(languageList: list));
                    } else if (listType == "education") {
                      bloc.add(UpdateNurseDataEvent(educationList: list));
                    } else if (listType == "publications") {
                      bloc.add(UpdateNurseDataEvent(publicationsList: list));
                    } else if (listType == "courses") {
                      bloc.add(UpdateNurseDataEvent(coursesList: list));
                    } else if (listType == "emergency_contacts") {
                      //if current user_type is patient
                      if (Util.isCustomer()) {
                        bloc.add(UpdateProfileEvent(user: {
                          "emergency_contacts":
                              bloc.emergencyContactsList.toString()
                        }));
                        return;
                      }
                      bloc.add(
                          UpdateNurseDataEvent(emergencyContactsList: list));
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
