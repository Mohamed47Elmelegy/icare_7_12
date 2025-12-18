import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/booking/presentation/bloc/order_bloc.dart';
import 'package:icare/features/booking/presentation/bloc/order_event.dart';
import 'package:icare/features/booking/presentation/bloc/order_state.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';

class MoreNeedWidget extends StatelessWidget {
  const MoreNeedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: translate('icare.more_need'),
          fontSize: AppStyle.average.sp,
        ),
        BlocBuilder<BookingBloc, BookingState>(
          builder: (ctx, state) {
            var bloc = BookingBloc.get(ctx);
            var list = [
              'تغيير الضمادات',
              'العناية بالقسطرة البولية',
              'العناية بأنبوب التغذية',
              'إعطاء الأدوية عن طريق الحقن',
              'جلسات علاج طبيعي',
              'رعاية ما بعد العمليات الجراحية',
              'رعاية مرضى الشيخوخة'
            ];
            return GridView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 30.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 11.w,
                  childAspectRatio: 6.w,
                  // mainAxisExtent: 100.h,
                ),
                itemBuilder: (BuildContext context, int index) {
                  var item = list[index];
                  return CheckboxListTile(
                    activeColor: kPrimary,
                    title:
                        CustomText(text: item, fontSize: AppStyle.small.sp - 2),
                    value: item.trim() == bloc.moreNeed.trim(),
                    onChanged: (value) => bloc.add(UpdateRequestFormDataEvent(
                        data: {'more_need': item.toString().trim()})),
                    onFocusChange: (value) => bloc.add(
                        UpdateRequestFormDataEvent(
                            data: {'more_need': item.toString().trim()})),
                  );
                });
          },
        )
      ],
    );
  }
}
