// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import 'package:icare/core/styles/app_style.dart';
// import 'package:icare/core/utils/dark_mode_utility.dart';
// import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
// import 'package:icare/features/account/presentation/bloc/account_event.dart';
// import 'package:icare/features/account/presentation/bloc/account_state.dart';
// import 'package:icare/features/account/presentation/screens/allergies_list_drop_down.dart';
// import 'package:icare/features/categories/presentation/bloc/cateogries_bloc.dart';
// import 'package:icare/features/categories/presentation/bloc/cateogries_state.dart';
// import 'package:icare/features/shared_widgets/custom_text.dart';
//
// class AddNewAllergiesWidget extends StatelessWidget {
//   const AddNewAllergiesWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CategoriesBloc,CategoriesState>(
//       builder: (ctx,state){
//         var catBloc = CategoriesBloc.get(ctx);
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             const AllergiesListDropDown(width: 200,),
//             BlocBuilder<AccountBloc,AccountState>(
//               builder: (ctx,state){
//                 var profileBloc = AccountBloc.get(ctx);
//                 // if(state is UpdateProfileState && state.response.isLoad==true)return CircularProgressIndicator(backgroundColor: DMUtil.getPC(),);
//                 return TextButton(
//                     onPressed: (){
//                       if(catBloc.currentAllergies!=null){
//                         profileBloc.currentUser!.allergiesList!.add(catBloc.currentAllergies!);
//                         if(profileBloc.currentUser!.allergiesList!=null && profileBloc.currentUser!.allergiesList!.isNotEmpty){
//                           AccountBloc.get(context).add(UpdateProfileEvent(user: {
//                             'services': profileBloc.convertAllergiesToIDS(),
//                           },));
//                         }
//                       }
//                     },
//                     child: Row(
//                       children: [
//                         CustomText(
//                           text: translate("button.add"),
//                           fontSize: AppStyle.small.sp,
//                           color: DMUtil.getPC(),
//                           textDecoration: TextDecoration.underline,
//                         ),
//                         Icon(Icons.add,size: 16.w,color: DMUtil.getPC(),),
//                       ],
//                     )
//                 );
//               },
//             )
//           ],
//         );
//       },
//     );
//   }
// }
