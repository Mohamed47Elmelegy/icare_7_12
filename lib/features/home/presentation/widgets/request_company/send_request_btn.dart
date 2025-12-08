import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';

class SendRequestBtn extends StatelessWidget {
  const SendRequestBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc,BookingState>(
      listener: (ctx,state){
        if(state is SendBookingRequestFormSuccessfullyState){
          AccountBloc.get(context).add(const FetchAllNotificationsEvent());
          Navigator.of(ctx).pop();
          SnackBarBuilder.showFeedBackMessage(context, translate('toast.success_msg'), kPrimary);
        }

        if(state is SendBookingRequestFialedState){
          SnackBarBuilder.showFeedBackMessage(context, state.msg.toString(), Colors.red);
          Navigator.of(ctx).pop();
        }
        
      },
      listenWhen: (previous, current) => current is SendBookingRequestLoadingState || current is SendBookingRequestFormSuccessfullyState || current is SendBookingRequestFialedState,
      child:  BlocBuilder<BookingBloc,BookingState>(
        builder: (ctx,state){
          var bloc = BookingBloc.get(ctx);
          if(state is SendBookingRequestLoadingState)return const CircularProgressIndicator(backgroundColor: kPrimary,);
          return CustomButton(
            height: 40.w,
            width: 300.w,
            widget: CustomText(
              text: translate("home.request"), 
              fontSize: AppStyle.average.sp + 2,
              color: kWhite,
            ),
            color: kPrimary, 
            onPressed: (){
              /// send request to all companies in same area around 10 killometters 
              bloc.add(const SendRequestDataEvent());
            },
          );
        },
      ),
    );
  }

  
}