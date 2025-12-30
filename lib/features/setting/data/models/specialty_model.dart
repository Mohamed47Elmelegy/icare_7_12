import 'dart:convert';
import 'package:icare/core/constants/constant.dart';
import 'package:icare/core/utils/shared_pref.dart';

class SpecialtyModel {
  final int id;
  final String title;

  SpecialtyModel({required this.id, required this.title});

  static List<SpecialtyModel> listFromJson(String str) =>
      List<SpecialtyModel>.from(
          json.decode(str).map((x) => SpecialtyModel.fromJson(x)));

  static SpecialtyModel fromJson(Map<String, dynamic> jsonObject) {
    String lang = SharedPref().getPreferenceString(Constants.userLang);
    String t = "";
    if (lang == 'ar') {
      t = jsonObject['title_ar'] ??
          jsonObject['title_en'] ??
          jsonObject['name'] ??
          jsonObject['title'] ??
          '';
    } else {
      t = jsonObject['title_en'] ??
          jsonObject['title_ar'] ??
          jsonObject['name'] ??
          jsonObject['title'] ??
          '';
    }

    return SpecialtyModel(
      id: jsonObject['id'],
      title: t,
    );
  }
}
