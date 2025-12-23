import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:flutter/material.dart';
import 'package:icare/features/account/presentation/widgets/doctor_widgets/doctor_options_value_row.dart';
import 'package:icare/features/authentication/presentation/widgets/nurse/add_btn_row.dart';
import 'package:icare/features/shared_widgets/custom_dialogs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class DoctorProfilePersonalTapScreen extends StatelessWidget {
  const DoctorProfilePersonalTapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddRowWithTitle(
          onTap: () async {
            var bloc = AccountBloc.get(context);
            var res = await CustomDialogs.addNewValue(context);
            if (res != null && res != "") {
              bloc.languageList ??= [];
              int index =
                  bloc.languageList!.indexWhere((element) => element == res);
              if (index != -1) return;
              bloc.languageList!.add(res);
              bloc.add(UpdateDoctorDataEvent(languageList: bloc.languageList));
            }
          },
          title: translate(
              "nurse.languages"), // Using existing translation key if suitable, assuming "languages" is generic
        ),
        const SizedBox(
          height: 10,
        ),
        const DoctorOptionsValueRowAccount(
          listType: "languages",
        ),
        Divider(
          height: 30.w,
        ),
        AddRowWithTitle(
          onTap: () async {
            var bloc = AccountBloc.get(context);
            var res = await CustomDialogs.addNewValue(context);
            if (res != null && res != "") {
              bloc.educationList ??= [];
              int index =
                  bloc.educationList!.indexWhere((element) => element == res);
              if (index != -1) return;
              bloc.educationList!.add(res);
              bloc.add(
                  UpdateDoctorDataEvent(educationList: bloc.educationList));
            }
          },
          title: translate("nurse.education"),
        ),
        const SizedBox(
          height: 10,
        ),
        const DoctorOptionsValueRowAccount(
          listType: "education",
        ),
        Divider(
          height: 30.w,
        ),
        AddRowWithTitle(
          onTap: () async {
            var bloc = AccountBloc.get(context);
            var res = await CustomDialogs.addNewValue(context,
                placeholderValue:
                    translate("nurse.experience_year_placeholder"));
            if (res != null && res != "") {
              bloc.publicationsList ??= [];
              int index = bloc.publicationsList!
                  .indexWhere((element) => element == res);
              if (index != -1) return;
              bloc.publicationsList!.add(res);
              bloc.add(UpdateDoctorDataEvent(
                  publicationsList: bloc.publicationsList));
            }
          },
          title: translate("nurse.experience_year"),
        ),
        const SizedBox(
          height: 10,
        ),
        const DoctorOptionsValueRowAccount(
          listType: "publications",
        ),
        Divider(
          height: 30.w,
        ),
        AddRowWithTitle(
          onTap: () async {
            var bloc = AccountBloc.get(context);
            var res = await CustomDialogs.addNewValue(context);
            if (res != null && res != "") {
              bloc.coursesList ??= [];
              int index =
                  bloc.coursesList!.indexWhere((element) => element == res);
              if (index != -1) return;
              bloc.coursesList!.add(res);
              bloc.add(UpdateDoctorDataEvent(coursesList: bloc.coursesList));
            }
          },
          title: translate("nurse.courses"),
        ),
        const SizedBox(
          height: 10,
        ),
        const DoctorOptionsValueRowAccount(
          listType: "courses",
        ),
      ],
    );
  }
}
