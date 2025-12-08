import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

class CaseDescription extends StatelessWidget {
  const CaseDescription({super.key});

  static final TextEditingController caseDescTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.w,),
      // padding: EdgeInsets.symmetric(vertical: 12.w,horizontal: 5.w),
      decoration: BoxDecoration(
          color: DMUtil.getWC(),
          borderRadius: BorderRadius.circular(10)
      ),
      child: BlocBuilder<BookingBloc,BookingState>(
        builder: (ctx,state){
          return CustomTextFromField(
            hintText: translate("booking.case_description"),
            height: 70,
            radius: 10,
            textEditingController: caseDescTextEditingController,
            validator: () {},
            textInputType: TextInputType.text,
            prefixIcon: Icon(Icons.description,color: DMUtil.getPC2(),size: 22.w,),
            suffixIcon: null,
            obscureText: false,
            isLabelError: false,
            hasBorder: false,
            borderWidth: 0,
            maxLines: 7,
            borderColor: DMUtil.getWC(),
            labelText: "",
          );
        },
      )
    );
  }
}
