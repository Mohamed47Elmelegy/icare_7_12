import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/screens/admin_screens/doctors/doctor_card.dart';
import 'package:icare/features/shared_widgets/empty_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorsList extends StatelessWidget {
  const DoctorsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc,AccountState>(
      builder: (ctx,state){
        var bloc = AccountBloc.get(ctx);
        if(state is FetchNotificationsLoadingState) return Center(child: CircularProgressIndicator(color: DMUtil.getPC2(),),);
        if(state is! FetchNotificationsLoadingState && bloc.notificationList.isEmpty) return const EmptyDataWidget();
        return Container(
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: ListView.separated(
            itemCount: bloc.allUsers.length,
            padding: EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w-20,vertical: 10.h),
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var item = bloc.allUsers[index];
              return DoctorCard(doctor: item,);
            },
            separatorBuilder: (BuildContext context, int index) => Divider(height: 20.w,),
          ),
        );
      },
    );
  }
}
