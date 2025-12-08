import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/authentication/presentation/widgets/gender_row.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/root_app/bloc/root_event.dart';
import 'package:icare/features/search/presentation/screens/map_search_screen.dart';
import 'package:icare/features/search/presentation/widgets/nearby_nurses.dart';
import 'package:icare/features/search/presentation/widgets/search_list.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';
import 'package:icare/features/shared_widgets/logo_widget.dart';




class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  static TextEditingController searchTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        const MapSearchScreen(isSet: false, ),
        Container(
          height: 180.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w,vertical: 10),
          decoration:  BoxDecoration(
              color: DMUtil.getPC()
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: translate("search.search"),
                color: DMUtil.getWC(),
                fontWeight: FontWeight.w600,
                fontSize: AppStyle.large.sp,
              ),
              SizedBox(height: 20.w,),
              const LogoWidget(width: 100,height: 53,isWhite: true,),
            ],
          ),
        ),

        Positioned(
          top: 240.w,
          child: const NearbyNurses()
        ),

        Positioned(
          top: 110.w,
          child: Container(
            height: 120.w,
            width: 320.w,
            padding: EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w),
            decoration: BoxDecoration(
              color: DMUtil.getWC(),
              borderRadius: const BorderRadius.all(Radius.circular(10))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextFromField(
                  hasBorder: true,
                  borderWidth: 0,
                  borderColor: DMUtil.getD2C(),
                  labelText: '',
                  height: 50,
                  hintText:  translate("search.select_area"),
                  radius: 10,
                  onChanged: (val)=>RootBloc.get(context).add(SearchEvent(word: val.toString().trim())),
                  onFieldSubmitted: (val)=> RootBloc.get(context).add(const SearchEvent(word: "")),
                  textEditingController: searchTextEditingController,
                  validator: () {},
                  prefixIcon: Icon(Icons.location_on_outlined,size: 20.w,),
                  suffixIcon: null,
                  isLabelError: false,
                  obscureText: false,
                ),
                const SizedBox(height: 10,),
               GenderRow(selectedColor: DMUtil.getPC(),txtColor: DMUtil.getD2C(),),
 
              ],
            ),
          ),
        ),


        Positioned(
          top: 180.w,
          child: const SearchListWidget(),
        ),

      ],
    );
  }
}
