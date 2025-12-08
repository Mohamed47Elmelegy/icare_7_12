import 'dart:convert';

class ReviewModel {
  final int? id ;
  final String? userName;
  final String? txt;
  final double? ratingValue;

  const ReviewModel({
    required this.id,
    required this.txt,
    required this.ratingValue,
    required this.userName,

  });

  static ReviewModel fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      userName: json['user_name'] ?? "",
      txt: json['comment'] ?? "",
      ratingValue: double.tryParse((json['rating']??"0").toString()) ?? 0,
    );
  }

  static List<ReviewModel> listModelFromJson(String str) =>
      List<ReviewModel>.from(
          json.decode(str).map((x) => ReviewModel.fromJson(x)));



  static calcReviewStar(List<ReviewModel>? list){
    if(list==null || list.isEmpty){
      return "⭐";
    }
    double average = 0;
    int calc = 0;
    for(var i in list){
      if(i.ratingValue!=null)calc = calc + i.ratingValue!.toInt();
    }
    average = calc / list.length;
    if(average==1 || average<1){
      return "⭐";
    }else if (average==2||average<2){
      return "⭐⭐";
    }else if (average==3||average<3){
      return "⭐⭐⭐";
    }else if (average==4||average<4){
      return "⭐⭐⭐⭐";
    }else if (average==5||average<5){
      return "⭐⭐⭐⭐⭐";
    }
  }
}