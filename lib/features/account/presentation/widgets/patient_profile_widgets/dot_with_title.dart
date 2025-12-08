import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';

class DotWithTitle extends StatelessWidget {
  final String title;
  final double titleWidth;
  final double editFieldWidth;
  const DotWithTitle({super.key,required this.title, this.titleWidth = 40,this.editFieldWidth=300,});

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    AccountBloc bloc = AccountBloc.get(context);
    if(bloc.currentPublication.trim()!="" && title.trim()=="publications")textEditingController.text = bloc.currentPublication;
    if(bloc.currentMedicalConditions.trim() !="" && title.trim()=="medical_conditions")textEditingController.text = bloc.currentMedicalConditions;
    String value = "";
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: DMUtil.getWC(),
            border: Border.all(width: 2.w,color: DMUtil.getD2C())
          ),
          child: CircleAvatar(
            radius: 1.w,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 4,),
        BlocBuilder<AccountBloc,AccountState>(
          builder: (ctx,state){
            var bloc = AccountBloc.get(ctx);
            var user = bloc.currentUser;
            if(user==null)return const SizedBox.shrink();
            if(bloc.enableUpdate==false || textEditingController.text.trim().isEmpty){
              if(title.trim()=="publications"){
                value = user.publications.toString();
                if(textEditingController.text.trim().isEmpty)textEditingController.text = value;
              }
              if(title.trim()=="medical_conditions"){
                value = user.medicalConditions.toString();
                if(textEditingController.text.trim().isEmpty)textEditingController.text = value;
              }
            }
            if(bloc.enableUpdate){
              return SizedBox(
                width: editFieldWidth.w,
                child: CustomTextFromField(
                  hasBorder: true,
                  borderWidth: 1,
                  borderColor: DMUtil.getD2C(),
                  labelText: '',
                  height: 60,
                  maxLines: 4,
                  hintText: '',
                  cursorColor: DMUtil.getD2C(),
                  radius: 10,
                  smallPadding: true,
                  onChanged: (val){
                    if(title.trim()=="medical_conditions"||title.trim()=="publications"){
                      bloc.add(UpdateUserPatientDataEvent(
                          data: {
                            title.trim():val.toString().trim()
                          },)
                        ,);
                    }
                  },
                  onFieldSubmitted: (val){},
                  textEditingController: textEditingController,
                  validator: () {},
                  prefixIcon: null,
                  obscureText: false,
                  suffixIcon: null,
                  isLabelError: false,
                ),
              );
            }
            return SizedBox(
              width: titleWidth.w,
              child: CustomText(
                text: value,
                fontSize: AppStyle.verySmall.sp,
                fontWeight: FontWeight.w600,
                color: DMUtil.getD2C(),
                isEllipsis: true,
                maxLine: 3,
              ),
            );
          },
        ),

      ],
    );
  }
}



class DotWithTitleView extends StatelessWidget {
  final String title;
  final double titleWidth;
  const DotWithTitleView({super.key,required this.title, this.titleWidth = 40});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: DMUtil.getWC(),
              border: Border.all(width: 2.w,color: DMUtil.getD2C())
          ),
          child: CircleAvatar(
            radius: 1.w,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 4,),
        SizedBox(
          width: titleWidth.w,
          child: CustomText(
            text: title,
            fontSize: AppStyle.verySmall.sp,
            fontWeight: FontWeight.w600,
            color: DMUtil.getD2C(),
            isEllipsis: true,
            maxLine: 3,
          ),
        )
      ],
    );
  }
}


class DotWithTitleAllergies extends StatelessWidget {
  final String title;
  final double titleWidth;
  final double editFieldWidth;
  const DotWithTitleAllergies({super.key,required this.title, this.titleWidth = 40,this.editFieldWidth=300,});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: DMUtil.getWC(),
              border: Border.all(width: 2.w,color: DMUtil.getD2C())
          ),
          child: CircleAvatar(
            radius: 1.w,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 4,),
        SizedBox(
          width: titleWidth.w,
          child: CustomText(
            text: title,
            fontSize: AppStyle.verySmall.sp,
            fontWeight: FontWeight.w600,
            color: DMUtil.getD2C(),
            isEllipsis: true,
            maxLine: 1,
          ),
        ),

        BlocBuilder<AccountBloc,AccountState>(
          builder: (ctx,state){
            var bloc = AccountBloc.get(ctx);
            if(!bloc.enableUpdate || bloc.currentUser==null || bloc.currentUser!.allergiesList==null)return const SizedBox.shrink();
            return InkWell(
              onTap: (){
                int index = bloc.currentUser!.allergiesList!.indexWhere((element) => element.value.trim().contains(title.trim()));
                if(index==-1)return;
                bloc.currentUser!.allergiesList!.removeAt(index);
                bloc.add(UpdateProfileEvent(user: {'allergies': bloc.convertAllergiesToIDS(),}));
              },
              child: Icon(Icons.remove_circle_outline,color: Colors.red,size: 15.w,),
            );
          },
        ),

      ],
    );
  }
}

