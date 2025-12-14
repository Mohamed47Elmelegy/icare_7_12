import 'package:icare/core/strings/app_images.dart';
import 'package:icare/features/shared_widgets/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageWidget extends StatelessWidget {
  final double height;
  final double width;
  final BoxFit fit;
  final String imgUrl;
  final String? errorImg;
  final double? radius;
  const ImageWidget({super.key,this.width=double.infinity,this.height=130,this.fit=BoxFit.fill,required this.imgUrl,this.errorImg,this.radius});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imgUrl,
      imageBuilder: (ctx,imgProvider){
        return Container(
          height: height.w,
          width: width.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 10),
            image: DecorationImage(
              image: imgProvider,
              fit: fit,
            ),
          ),
        );
      },
      height: height.h,
      width: width.h,
      fit: fit,
      placeholder: (context, url) => LoadingWidget(height: height.h,),
      errorWidget: (context, url, error) {
        final fallbackImage = errorImg ?? AppImages.logo;
        // Check if the image is SVG
        if (fallbackImage.toLowerCase().endsWith('.svg')) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(radius ?? 10),
            child: SvgPicture.asset(
              fallbackImage,
              height: height.h,
              width: width.h,
              fit: fit,
            ),
          );
        }
        // Otherwise use regular Image.asset
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 10),
          child: Image.asset(
            fallbackImage,
            height: height.h,
            width: width.h,
            fit: fit,
          ),
        );
      },
    );
  }
}
