import 'dart:convert';

class FaqsModel{
  final String? title;
  final List<FaqModel>? faqList;
  const FaqsModel({required this.title,required this.faqList});
}


class FaqModel{
  final String? title;
  final String? content;
  const FaqModel({required this.title,required this.content});

  static FaqModel fromJsonProducts(Map<String, dynamic> json) {
    return FaqModel(
      content: json['content'] ?? "",
      title: json['title'] ?? "",
    );
  }


  static List<FaqModel> listModelFromJson(String str) =>
      List<FaqModel>.from(
          json.decode(str).map((x) => FaqModel.fromJsonProducts(x)));

}