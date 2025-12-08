import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/align_child_by_row.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';

class AddNewOptionValue extends StatelessWidget {
  const AddNewOptionValue({super.key,this.placeHolderValue});
  final String? placeHolderValue;
  static final TextEditingController textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: DMUtil.getWC(),
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlignChildRow(
              child: InkWell(
                onTap: ()=> Navigator.pop(context),
                child: CircleAvatar(
                  radius: 12.w,
                  backgroundColor: DMUtil.getOpacity(),
                  child: Icon(Icons.close,color: Colors.red,size: 18.w,),
                )
              )
          ),
          const SizedBox(height: 20,),
          CustomTextFromField(
            hasBorder: true,
            borderWidth: 1,
            borderColor: DMUtil.getD2C(),
            labelText: '',
            height: 45,
            hintText: placeHolderValue ?? translate("icare.add_option_value"),
            radius: 10,
            onChanged: (val){},
            onFieldSubmitted: (val){},
            textEditingController: textEditingController,
            validator: () {},
            prefixIcon: null,
            obscureText: false,
            isLabelError: false,
          ),

          const SizedBox(height: 20,),
          TextButton(
              onPressed: (){
                Navigator.pop(context,textEditingController.text.trim());
                textEditingController.text = "";
              },
              child: CustomText(
                text: translate("button.save"),
                fontSize: AppStyle.small.sp,
                fontWeight: FontWeight.w600,
              ),
          ),
        ],
      ),
    );
  }
}
