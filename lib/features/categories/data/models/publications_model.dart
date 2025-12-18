import 'dart:convert';

import 'package:icare/features/categories/domain/entities/publications_entity.dart';

class PublicationsModel extends PublicationsEntity {
  const PublicationsModel(
      {required super.id,
      required super.title,
      required super.imgUrl,
      required super.videoUrl});

  static PublicationsModel fromJson(Map<String, dynamic> json) {
    return PublicationsModel(
      id: json['id'],
      title: json['title'] ?? "",
      imgUrl: json['banner'] ?? "",
      videoUrl: json['video_url'] ?? "",
    );
  }

  static List<PublicationsModel> listFromJson(String str) =>
      List<PublicationsModel>.from(
          json.decode(str).map((x) => PublicationsModel.fromJson(x)));

  static List<PublicationsModel> listDFromJson(var str) {
    return str.map<PublicationsModel>((categoryModel) {
      return PublicationsModel.fromJson(categoryModel);
    }).toList();
  }
}
