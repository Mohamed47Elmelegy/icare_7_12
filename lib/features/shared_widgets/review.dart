
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';


class ReviewsWidget extends StatelessWidget {
  final int amount;
  final Color color;
  const ReviewsWidget({super.key,required this.amount,required this.color});

  @override
  Widget build(BuildContext context) {
    if(amount <= 10){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          Icon(Icons.star,size: 12.w,color: color,),
        ],
      );
    }else if (amount <= 50 && amount >10){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          Icon(Icons.star,size: 12.w,color: color,),
          Icon(Icons.star,size: 12.w,color: color,),
        ],
      );
    }else if (amount <= 100 && amount > 50){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          Icon(Icons.star,size: 12.w,color: color,),
          Icon(Icons.star,size: 12.w,color: color,),
          Icon(Icons.star,size: 12.w,color: color,),
        ],
      );
    }else if (amount <= 150 && amount >100){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          Icon(Icons.star,size: 12.w,color: color,),
          Icon(Icons.star,size: 12.w,color: color,),
          Icon(Icons.star,size: 12.w,color: color,),
          Icon(Icons.star,size: 12.w,color: color,),
        ],
      );
    }else if (amount <= 200 && amount >150){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          Icon(Icons.star,size: 12.w,color: color,),
          Icon(Icons.star,size: 12.w,color: color,),
          Icon(Icons.star,size: 12.w,color: color,),
          Icon(Icons.star,size: 12.w,color: color,),
          Icon(Icons.star,size: 12.w,color: color,),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}


class ReviewWidgetView extends StatelessWidget {
  final double rate;
  const ReviewWidgetView({super.key,required this.rate});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rate,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 10.w,
      itemBuilder: (context, _) =>  Icon(
        Icons.star,
        color: DMUtil.getReviewColor(),
      ),
      onRatingUpdate: (rating) {
        return;
      },
      ignoreGestures: true,
    );
  }
}

