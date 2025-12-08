import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/account/presentation/bloc/account_bloc.dart';
import 'package:icare/features/account/presentation/bloc/account_event.dart';
import 'package:icare/features/account/presentation/bloc/account_state.dart';
import 'package:icare/features/categories/data/models/services.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';

class ServicesListDropDown extends StatelessWidget {
  final double width;
  const ServicesListDropDown({super.key,this.width = 110});
  static final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc,AccountState>(
      builder: (ctx,state){
        var bloc = AccountBloc.get(ctx);
        var list = bloc.allServiceList;
        if(list.isEmpty)return const SizedBox.shrink();
        var currentItem = bloc.currentService;
        // currentItem ??= list.first;
        return Column(
          children: [
            Container(
              width: width.w,
              decoration: BoxDecoration(
                  color: DMUtil.getWC(),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1,color:  DMUtil.getOpacity())
              ),
              child: DropdownButton<ServicesModel>(
                value: null,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 10,
                menuMaxHeight: 250.h,
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomText(
                    text:currentItem==null? translate("icare.select_service"): currentItem.value,
                    fontSize: AppStyle.small.sp,
                    color: DMUtil.getD2C(),
                  ),
                ),
                isExpanded: true,
                style: TextStyle(color: DMUtil.getD2C()),
                underline: const SizedBox(),
                onChanged: (ServicesModel? newValue) => bloc.add(ChangeCurrentService(item: newValue!)),
                items: list.map<DropdownMenuItem<ServicesModel>>((ServicesModel item) {
                  return DropdownMenuItem<ServicesModel>(
                    value: item,
                    child: CustomText(
                      text: item.value.toString(),
                      fontSize: AppStyle.small.sp,
                    ),
                  );
                }).toList(),
              ),
            ),

            if(currentItem!=null)...[
              const SizedBox(height: 10,),
              CustomTextFromField(
                hasBorder: true,
                borderWidth: 1,
                borderColor: DMUtil.getD2C(),
                labelText: '',
                height: 45,
                hintText: translate("icare.select_price"),
                radius: 10,
                onChanged: (val)=> bloc.add(ChangeCurrentService(item: currentItem,txt: val.toString().trim())),
                onFieldSubmitted: (val){},
                textEditingController: textEditingController,
                validator: () {},
                prefixIcon: null,
                obscureText: false,
                isLabelError: false,
              ),

              const SizedBox(height: 20,),

            ],
          ],
        );
      },
    );
  }
}
