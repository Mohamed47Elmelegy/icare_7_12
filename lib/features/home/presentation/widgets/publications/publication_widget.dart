import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/features/categories/domain/entities/publications_entity.dart';
import 'package:icare/features/home/presentation/widgets/publications/video_widget.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/global_app_image.dart';



class PublicationWidget extends StatelessWidget {
  final PublicationsEntity item;
  const PublicationWidget({super.key,required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: item.title,
          fontSize: AppStyle.average.sp,
        ),
        const SizedBox(height: 5,),
        if(item.videoUrl!="")...[
          VideoWidget(item: item),
        ]else...[
          Align(
            child: ImageWidget(imgUrl: item.imgUrl,height: 210,fit: BoxFit.fill,),
          ),
        ]
      ],
    );
  }
}