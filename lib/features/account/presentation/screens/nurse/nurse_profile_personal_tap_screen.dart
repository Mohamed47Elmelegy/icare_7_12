import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:flutter/material.dart';
import 'package:icare/features/account/presentation/widgets/nurse_widgets/edit_info_list.dart';
import 'package:icare/features/authentication/presentation/widgets/nurse/add_btn_row.dart';
import 'package:icare/features/shared_widgets/custom_dialogs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';


class NurseProfilePersonalTapScreen extends StatelessWidget {
  const NurseProfilePersonalTapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddRowWithTitle(
          onTap: ()async{
            var bloc = AccountBloc.get(context);
            var res = await CustomDialogs.addNewValue(context);
            if(res !=null && res != ""){
              bloc.languageList ??= [];
              int index = bloc.languageList!.indexWhere((element) => element == res);
              if(index!=-1)return;
              bloc.languageList!.add(res);
              bloc.add(UpdateNurseDataEvent(languageList: bloc.languageList));
            }
          },
          title: translate("nurse.languages"),
        ),
        const SizedBox(height: 10,),
        const NurseOptionsValueRowAccount(listType: "languages",),
        Divider(height: 30.w,),

        AddRowWithTitle(
          onTap: ()async{
            var bloc = AccountBloc.get(context);
            var res = await CustomDialogs.addNewValue(context);
            if(res !=null && res != ""){
              bloc.educationList ??= [];
              int index = bloc.educationList!.indexWhere((element) => element == res);
              if(index!=-1)return;
              bloc.educationList!.add(res);
              bloc.add(UpdateNurseDataEvent(educationList: bloc.educationList));
            }
          },
          title: translate("nurse.education"),
        ),
        const SizedBox(height: 10,),
        const NurseOptionsValueRowAccount(listType: "education",),


        Divider(height: 30.w,),
        AddRowWithTitle(
          onTap: ()async{
            var bloc = AccountBloc.get(context);
            var res = await CustomDialogs.addNewValue(context,placeholderValue: translate("nurse.experience_year_placeholder"));
            if(res !=null && res != ""){
              bloc.publicationsList ??= [];
              int index = bloc.publicationsList!.indexWhere((element) => element == res);
              if(index!=-1)return;
              bloc.publicationsList!.add(res);
              bloc.add(UpdateNurseDataEvent(publicationsList: bloc.publicationsList));
            }
          },
          title: translate("nurse.experience_year"),
        ),
        const SizedBox(height: 10,),
        const NurseOptionsValueRowAccount(listType: "publications",),

        Divider(height: 30.w,),
        AddRowWithTitle(
          onTap: ()async{
            var bloc = AccountBloc.get(context);
            var res = await CustomDialogs.addNewValue(context);
            if(res !=null && res != ""){
              bloc.coursesList ??= [];
              int index = bloc.coursesList!.indexWhere((element) => element == res);
              if(index!=-1)return;
              bloc.coursesList!.add(res);
              bloc.add(UpdateNurseDataEvent(coursesList: bloc.coursesList));
            }
          },
          title: translate("nurse.courses"),
        ),
        const SizedBox(height: 10,),
        const NurseOptionsValueRowAccount(listType: "courses",),

      ],
    );
  }
}