
import 'dart:convert';
import 'package:icare/features/categories/domain/entities/categories_entity.dart';



class CategoriesModel  extends CategoriesEntity{
  const CategoriesModel(
      {required super.id,
      required super.slug,
        required  super.imgPath,
        required  super.title,
        required  super.desc,
        required super.iconPath,
        required super.darkIcon,
        required super.lightIcon,
        required super.isArabic,
        required super.parentID,
        required super.productsCount,
        required super.enableHomeScreen,
      });

  static CategoriesModel fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json['id'],
      slug: json['slug'] ?? "",
      title: json['name'] ?? json['title'],
      desc: json['desc'] ?? "",
      imgPath: json['image'] ?? "",
      iconPath: json['icon'] ?? "",
      darkIcon: json['dark_icon'] ?? " ",
      lightIcon: json['light_icon'] ?? "",
      isArabic: json['is_arabic'] ?? false,
      enableHomeScreen: json['show_on_mobile'] ?? false,
      parentID: (json['parent']??0).toString(),
      productsCount: int.parse((json['products_count']!=null&&json['products_count']!=""?json['products_count']:0).toString()),
    );
  }

  static CategoriesModel fromJsonAllergies(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json['id'],
      slug: json['slug'] ?? "",
      title: json['value'] ?? json['title'],
      desc: json['desc'] ?? "",
      imgPath: json['image'] ?? "",
      iconPath: json['icon'] ?? "",
      darkIcon: json['dark_icon'] ?? " ",
      lightIcon: json['light_icon'] ?? "",
      isArabic: json['is_arabic'] ?? false,
      enableHomeScreen: json['show_on_mobile'] ?? false,
      parentID: (json['parent']??0).toString(),
      productsCount: int.parse((json['products_count']!=null&&json['products_count']!=""?json['products_count']:0).toString()),
    );
  }


  static Map<String, dynamic> toJsonLocal(CategoriesEntity item) {
    return {
      "id":int.tryParse(item.id.toString()),
      'slug': item.slug,
      'title': item.title.toString(),
      'desc': item.desc.toString(),
      'image': item.imgPath.toString(),
      'name': item.darkIcon,
      // 'name': item.lightIcon,
      'is_arabic': item.isArabic,
      'parent': item.parentID,
      'show_on_mobile': item.enableHomeScreen,
      'products_count':item.productsCount,
    };
  }
  static CategoriesModel fromJsonProductsLocal(Map<String, dynamic> json) {
    return CategoriesModel(
      slug: json['slug']??"",
      id: json['term_id']??json['id']??"0",
      title: json['name']??"",
      desc: json['desc']??"",
      imgPath: json['guid']??"",
      iconPath: json['icon']??"",
      darkIcon: json['dark_icon'],
      lightIcon: json['light_icon'],
      isArabic: json['is_arabic']??false,
      enableHomeScreen:json['show_on_mobile']??false,
      parentID: (json['parent']??0).toString(),
      productsCount: int.parse((json['products_count']!=null&&json['products_count']!=""?json['products_count']:0).toString()),
    );
  }


  static CategoriesModel fromJsonProducts(Map<String, dynamic> json) {
    return CategoriesModel(
      slug: json['slug']??"",
      id: json['term_id']??json['id']??"0",
      title: json['name']??"",
      desc: json['desc']??"",
      imgPath: json['guid']??"",
      iconPath: json['icon']??"",
      darkIcon: json['dark_icon'],
      lightIcon: json['light_icon'],
      isArabic: json['is_arabic']??false,
      enableHomeScreen:json['show_on_mobile']??false,
      parentID: (json['parent']??0).toString(),
      productsCount: int.parse((json['products_count']!=null&&json['products_count']!=""?json['products_count']:0).toString()),
    );
  }

  static List<CategoriesModel> listModelFromJsonLocal(String str) =>
      List<CategoriesModel>.from(
          json.decode(str).map((x) => CategoriesModel.fromJsonProductsLocal(x)));


  static List<CategoriesModel> listModelFromJson(String str) =>
      List<CategoriesModel>.from(
          json.decode(str).map((x) => CategoriesModel.fromJsonProducts(x)));

}
