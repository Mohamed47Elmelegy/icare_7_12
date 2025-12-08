import 'package:icare/features/shared_widgets/loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_bloc.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_event.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_state.dart';
import 'package:icare/features/shared_widgets/global_app_image.dart';

class SliderWidget extends StatelessWidget {
  final double height;
  const SliderWidget({super.key,this.height = 170});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: BlocBuilder<CategoriesBloc,CategoriesState>(
        builder: (ctx,state){
          var bloc = CategoriesBloc.get(ctx);
          var list = bloc.mainSlider;
          list = bloc.filterSliderByLang(list);
          if(state is FetchSliderLoadingState)return LoadingShimmer(height: 200.h,width: double.infinity,);
          // if(state==FetchStates.FAILED)return CustomText(text: translate("toast.oops"), color: Colors.red, fontSize: 12);
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: height.w ,
                width: double.infinity,
                child:  CarouselSlider.builder(
                  itemCount: list.length,
                  options: CarouselOptions(
                    autoPlay: list.length<=1?false:true,
                    enableInfiniteScroll: list.length<=1?false:true,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    onPageChanged: (index,reason)=> bloc.add(ChangeSliderIndexEvent(val: index)),
                  ),
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                    var item = list[itemIndex];
                    return InkWell(
                        child: ImageWidget(
                          imgUrl: item.img,
                          fit: BoxFit.fill,
                          width: double.infinity,
                        ));
                  },
                ),
              ),
              if(list.length>1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for(int i = 0 ; i<list.length; i++)...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 3),
                      child: bloc.currentSliderIndex==i?
                      Container(
                        width: 13.w,
                        height: 8.h,
                        decoration: const BoxDecoration(
                          color:  Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                      ): Icon(Icons.circle,color: Colors.black38,size: 9.w,),
                    ),
                  ],
                ],
              ),

            ],
          );
        },
      ),
    );
  }
}
