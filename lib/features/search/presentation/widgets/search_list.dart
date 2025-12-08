import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/root_app/bloc/root_event.dart';
import 'package:icare/features/root_app/bloc/root_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class SearchListWidget extends StatelessWidget {
  const SearchListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootBloc,RootState>(
      builder: (ctx,state){
        var bloc = RootBloc.get(ctx);
        var list = bloc.currentAreaList;
        if(list.isEmpty)return const SizedBox.shrink();
        return Container(
          decoration: BoxDecoration(
              color: DMUtil.getWC(),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1,color: DMUtil.getBackGround())
          ),
          height: 200.w,
          width: 290.w,
          child: Scrollbar(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                var item = list[index];
                if(item==null)return const SizedBox.shrink();
                return InkWell(
                  onTap: ()=> bloc.add(ChooseCurrentAreaEvent(area: item)),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined,size: 14.w,),
                      const SizedBox(width: 5,),
                      CustomText(
                        text: item.title.toString(),
                        fontSize: AppStyle.small.sp,
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (ctx,index)=> const Divider(),
              itemCount: list.length,
            ),
          ),
        );
      },
    );
  }
}
