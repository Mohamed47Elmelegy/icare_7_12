

import 'package:icare/features/categories/domain/entities/slider_entity.dart';

class SliderModel extends SliderEntity{
  const SliderModel({required super.title,
    required super.kind,
    required super.type,
    required super.typeID,
    required super.img,
    required super.id});

  static SliderModel fromJson(Map<String, dynamic> jsonObject) {
    return SliderModel(
      id: jsonObject['ID']??"",
      title: jsonObject['post_title']??"",
      img: jsonObject['img'] ?? "",
      type: jsonObject['type'] ?? "",
      typeID: jsonObject['type_id'] ?? "",
      kind: jsonObject['kind'] ?? "",
    );
  }
}


