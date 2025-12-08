// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:icare/core/styles/app_style.dart';
// import 'package:icare/core/utils/dark_mode_utility.dart';
// import 'package:icare/features/nurse/presentation/bloc/nurse_state.dart';
// import 'package:icare/features/nurse/presentation/bloc/nurses_bloc.dart';
// import 'package:icare/features/nurse/presentation/widgets/small_card_nurse_details.dart';
// import 'package:icare/features/shared_widgets/custom_text.dart';
//
//
// class ExtraOptionsNurseCardView extends StatelessWidget {
//   const ExtraOptionsNurseCardView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<NurseBloc,NurseState>(
//       builder: (ctx,state){
//         var bloc = NurseBloc.get(ctx);
//         var currentNurse = bloc.currentNurse;
//         if(currentNurse==null || currentNurse.userData ==null)return const SizedBox.shrink();
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//
//             CustomText(
//               text: currentNurse.userData!.userName.toString(),
//               fontWeight: FontWeight.w600,
//               fontSize: AppStyle.small.sp,
//             ),
//             CustomText(
//               text: "Dentist",
//               fontSize: AppStyle.small.sp,
//               color: DMUtil.getD2C(),
//             ),
//             CustomText(
//               text: "2 Rue de Ermesinde Frisange - Luxembourg 3",
//               fontSize: AppStyle.small.sp,
//               color: DMUtil.getD2C(),
//               alignCenter: false,
//               maxLine: 2,
//             ),
//
//             const SizedBox(height: 10,),
//
//             const Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 SmallProfileCards(title: "10K", subTitle: "patients",),
//                 SizedBox(width: 5,),
//                 SmallProfileCards(title: "5 years", subTitle: "experience",),
//                 SizedBox(width: 5,),
//                 SmallProfileCards(title: "5.0", subTitle: "Avg Rating",),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
// }