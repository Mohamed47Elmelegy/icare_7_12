import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/account/presentation/widgets/notifications_widgets/notification_card.dart';
import 'package:icare/features/shared_widgets/empty_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc,AccountState>(
      builder: (ctx,state){
        var bloc = AccountBloc.get(ctx);
        if(state is FetchNotificationsLoadingState) return const Center(child: CircularProgressIndicator(color: kPrimary,),);
        if(state is! FetchNotificationsLoadingState && bloc.notificationList.isEmpty) return const EmptyDataWidget();
        return ListView.separated(
          itemCount: bloc.notificationList.length,
          padding: EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w,vertical: 25.h) + EdgeInsets.only(bottom:bloc.notificationList.length>15? 40 : 200),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            var item = bloc.notificationList[index];
            return NotificationListCard(item: item,);
          },
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 20.w,),
        );
      },
    );
  }
}